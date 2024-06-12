# check_true_false.py

from typing import List, Literal
import argparse
import os
from utils import Not, Statement, parse_line
from tt_entails import tt_entails
import time


def get_args():
    parser = argparse.ArgumentParser("check_true_false")
    parser.add_argument("--rules", type=str, required=True)
    parser.add_argument("--additional_knowledge", type=str, required=True)
    parser.add_argument("--statement", type=str, required=True)
    return parser.parse_args()


def check_args_files(args):
    assert os.path.exists(args.rules), f'{args.rules} not exists.'
    assert os.path.exists(args.additional_knowledge), f'{args.additional_knowledge} not exists.'
    assert os.path.exists(args.statement), f'{args.statement} not exists.'


def parse_rules(rules_file):
    rules = []
    with open(rules_file, 'r') as f:
        lines = f.readlines()
        for line in lines:
            line = line.strip()
            if line == '' or line[0] == '#':
                continue
            rules.append(parse_line(line))
    return rules


def check_true_false(
    wumpus_world: List[Statement],
    additional_knowledge: List[Statement],
    statement: Statement
) -> Literal['True', 'False', 'Unknown']:
    """
    此处请你实现你的推理程序。
    wumpus_world为输入的规则列表
    additional_knowledge为输入的观测到的逻辑变量的列表
    statement为你需要推理的内容
    """
    l0 = tt_entails(wumpus_world, additional_knowledge, statement)
    l1 = tt_entails(wumpus_world, additional_knowledge, Not([statement]))
    """
    TODO 7:
        请根据l0和l1的值返回'True'、'False'或'Unknown'
    """
    # 仅l0为真则推理结果为True
    # 仅l1为真则推理结果为False
    # 其他情况均为Unknown
    if l0 and not l1:
        return 'True'
    elif not l0 and l1:
        return 'False'
    else:
        return 'Unknown'



def main(args) -> List[str]:
    wumpus_rules = parse_rules(args.rules)
    additional_knowledge = parse_rules(args.additional_knowledge)
    tik = time.time()
    results = [check_true_false(wumpus_rules, additional_knowledge, statement)
                for statement in parse_rules(args.statement)]
    tok = time.time()
    print(tok - tik)
    return results


if __name__ == '__main__':
    args = get_args()
    check_args_files(args)
    results = main(args)
    with open('./result.txt', 'w') as f:
        for line in results:
            f.write(line + '\n')
