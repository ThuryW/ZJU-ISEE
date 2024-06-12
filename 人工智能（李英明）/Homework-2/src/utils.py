# utils.py

from typing import Dict, List
from functools import reduce


##################################################
# Define Statements                              #
# including Atom, And, Or, Xor, Not, If, and Iff #
# `Atom` represents single variable              #
##################################################

class Statement(object):
    def __init__(self) -> None:
        self.atom_set = set()
        self.operator = None
        self.statements = []

    def eval(self, atom_dict: Dict[str, bool]):
        raise NotImplementedError

    def __str__(self):
        if self.operator == 'ATOM':
            return '(ATOM ' + self.name + ')'
        else:
            return '(' + ' '.join([self.operator, *[str(s) for s in self.statements]]) + ')'


class Atom(Statement):
    def __init__(self, name: str) -> None:
        self.operator = 'ATOM'
        self.name = name
        self.atom_set = {name.strip()}

    def eval(self, atom_dict: Dict[str, bool]):
        v = atom_dict[self.name]
        return atom_dict[self.name]


class And(Statement):
    def __init__(self, statements: List[Statement]):
        self.operator = 'AND'
        self.statements = statements
        self.atom_set = reduce(set.union, [s.atom_set for s in statements], set())

    def eval(self, atom_dict: Dict[str, bool]):
        for s in self.statements:
            if not s.eval(atom_dict):
                return False
        return True


class Or(Statement):
    def __init__(self, statements: List[Statement]) -> None:
        self.operator = 'OR'
        self.statements = statements
        self.atom_set = reduce(set.union, [s.atom_set for s in statements], set())

    def eval(self, atom_dict: Dict[str, bool]):
        for s in self.statements:
            if s.eval(atom_dict):
                return True
        return False


class Xor(Statement):
    def __init__(self, statements: List[Statement]) -> None:
        self.operator = 'XOR'
        self.statements = statements
        self.atom_set = reduce(set.union, [s.atom_set for s in statements], set())

    def eval(self, atom_dict: Dict[str, bool]):
        cnt = 0
        for s in self.statements:
            if s.eval(atom_dict):
                cnt += 1
                if cnt > 1:
                    return False
        return cnt == 1


class Not(Statement):
    def __init__(self, statements: List[Statement]) -> None:
        self.operator = 'NOT'
        self.statements = statements
        self.atom_set = reduce(set.union, [s.atom_set for s in statements], set())
        assert len(self.statements) == 1, 'syntax error'

    def eval(self, atom_dict: Dict[str, bool]):
        """
        TODO 1:
            编写正确的代码段，使得该类的.eval方法可以返回单表达式的否定。
        提示：
            Not类的self.statements为一个仅含有1个元素的列表，因此返回self.statements[0]的否定即可
        """
        # 返回self.statements[0].eval(atom_dict)的否定值
        return not self.statements[0].eval(atom_dict)


class If(Statement):
    def __init__(self, statements: List[Statement]) -> None:
        self.operator = 'IF'
        self.statements = statements
        self.atom_set = reduce(set.union, [s.atom_set for s in statements], set())
        assert len(self.statements) == 2, 'syntax error'

    def eval(self, atom_dict: Dict[str, bool]):
        """
        TODO 2:
            编写正确的代码段，使得该类的.eval方法可以返回正确的蕴含表达式值。
        """ 
        # 若P蕴含Q（P→Q），则有：
        #   P为假，则P→Q为真
        #   P为真，则仅当Q也为真时P→Q为真
        # 因此仅当P真Q假时P→Q返回False，其他情况都返回True
        if self.statements[0].eval(atom_dict) and not self.statements[1].eval(atom_dict):
            return False
        else:
            return True


class Iff(Statement):
    def __init__(self, statements: List[Statement]) -> None:
        self.operator = 'IFF'
        self.statements = statements
        self.atom_set = reduce(set.union, [s.atom_set for s in statements], set())
        assert len(self.statements) == 2, 'syntax error'

    def eval(self, atom_dict: Dict[str, bool]):
        """
        TODO 3:
            编写正确的代码段，使得该类的.eval方法可以返回正确的双向蕴含表达式值。
        """
        # 若P iff Q，则仅当P、Q同为真或同为假时返回Ture，否则返回False
        # 因此若P、Q的eval值相等则返回True，否则返回False
        if self.statements[0].eval(atom_dict) == self.statements[1].eval(atom_dict):
            return True
        else:
            return False
        

##################################################
# some useful functions                          #
##################################################

def is_atom(s: Statement):
    return isinstance(s, Atom)

##################################################
# parse_line                                     #
# statement ::= atom | (operator [statement])    #
# operator ::= and | or | xor | not | if | iff   #
##################################################

# 运算符映射表
operator_mapping = {
    'AND': And,
    'OR': Or,
    'XOR': Xor,
    'NOT': Not,
    'IF': If,
    'IFF': Iff
}


def parse_line(line: str) -> Statement:
    """
    把字符串转化成表达式
    """
    line = line.strip()
    if line[0] != '(':
        # 没有运算符，为单变量
        return Atom(line)

    # 分离运算符和子表达式
    line = line[1:-1].strip()  # 去最外层括号
    l_split = line.split()
    operator = l_split[0].upper()  # 得到大写字母形式的运算符
    line = ' '.join(l_split[1:]).strip()
    statement_cls = operator_mapping[operator]  # 得到运算符类别

    statements = []

    while line != '':
        if line[0] == '(':
            # 当前子表达式不是单变量
            t = 0  # 记录匹配的括号状态
            l = len(line)
            for i in range(l):
                if line[i] == '(':
                    t += 1
                elif line[i] == ')':
                    t -= 1
                    if t == 0:
                        statements.append(parse_line(line[:i + 1]))
                        line = line[i + 1:].strip()
                        break
        else:
            t = 0
            l = len(line)
            for i in range(l):
                if line[i] == ' ':
                    t = i
                    statements.append(parse_line(line[:t]))
                    line = line[t:].strip()
                    break
            # 当前子表达式是最后一个
            if t == 0:
                statements.append(parse_line(line))
                line = ''

    return statement_cls(statements)  # 记录一行规则
