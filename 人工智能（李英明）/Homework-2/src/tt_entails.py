from typing import List
from utils import *


def tt_entails(KB_a: List[Statement], KB_b: List[Statement], alpha: Statement):
    symbol_set = And(KB_a).atom_set.union(alpha.atom_set)  # 符合集合
    model = dict()  # 初始化model
    for expr in KB_b:  # b.txt中都是单变量表达式，要么为Atom，要么为Not
        if is_atom(expr):  # 是一个Atom表达式，因此该表达式对应的陈述为真
            # 因为是Atom，直接用self.name即可取出逻辑变量名
            model[expr.name] = True
        else:  # 是一个NOT-表达式，因此该表达式对应的陈述为假
            # 为NOT表达式，变量名在statements[0]中
            model[expr.statements[0].name] = False
    # symbol_set是一个集合，“-”是一种集合运算
    # 要去掉的以赋值的变量，以赋值的变量即字典model的键，因此将model的键组成新的集合即可      
    symbol_set -= set(model.keys())  # 根据readme的四、TT-Entails?的实现，可以在symbol_set中去掉那些已经由b.txt赋值了逻辑变量
    """
    TODO 4:
        请用合理的表达式替换'+_+'、'?_?'和'x_x'
    """
    return tt_check_all2(And(KB_a), alpha, list(symbol_set), model)  # 用tt_check_all1或tt_check_all2都是可以的


def tt_check_all1(KB: Statement, alpha: Statement, symbols, model):
    if symbols == []:
        return If([KB, alpha]).eval(model)
    P = symbols[0]
    rest = symbols[1:]
    """
    TODO 5:
        请根据readme的五、TT-Check-All的实现编写合理的代码段
    提示:
        在model中将P分别设为False和True，调用tt_check_all1进行递归
        在两种情况分别处理后，将P从model中删去
    """
    # 分别将P设为True和False加入字典model，只要有一种情况为假则整个蕴含关系为假
    # 完成判断后删去P
    model[P] = True
    if not tt_check_all1(KB, alpha, rest, model):
        model.pop(P)
        return False
    model[P] = False
    if not tt_check_all1(KB, alpha, rest, model):
        model.pop(P)
        return False
    model.pop(P)
    return True


def tt_check_all2(KB: Statement, alpha: Statement, symbols, model):
    if symbols == []:
        if pl_true(KB, model):
            return pl_true(alpha, model)
        else:
            return True
    P = symbols[0]
    rest = symbols[1:]
    """
    TODO 5:
    跟上面的TODO 5是一样的，把tt_check_all1都替换成tt_check_all2即可
    """
    model[P] = True
    if not tt_check_all2(KB, alpha, rest, model):
        model.pop(P)
        return False
    model[P] = False
    if not tt_check_all2(KB, alpha, rest, model):
        model.pop(P)
        return False
    model.pop(P)
    return True


def pl_true(expression: Statement, model: dict):
    """
    TODO 6:
        请补全PL_True?的实现
    提示：
        可以直接基于Statement类的.eval方法，或者根据readme中的伪代码实现
    """
    # 直接基于Statement类的.eval方法即可，同时也是最快的方法
    return expression.eval(model)
