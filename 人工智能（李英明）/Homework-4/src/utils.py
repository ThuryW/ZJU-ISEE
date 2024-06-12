import numpy as np
from typing import Tuple, List, Dict


# ******************************** Define the Bayesian Network Given Local Conditional Probabilities ******************************** #
# 定义贝叶斯网络中共有n个节点，第i个节点有m_i个属性值[v_i_0, v_i_1, ..., v_i_{m_i-1}]
# 为了方便python中的下标取值，节点下标和属性值下标都从0开始
# size定义了每个节点对应的属性值个数，即(m_0, m_1, ..., m_n-1)
size = (2, 2, 3, 2, 2)

# loc_cond_prob为local conditional probability
# loc_cond_prob[idx][state]描述了第idx个节点在state中的局部条件概率
# 其中state=(v_0, v_1, ..., v_n-1)，即state[idx]为第idx个节点在当前联合中的属性值
# eg. state=(0, 0, 1, 1, 0)代表了(d0, i0, g1, s1, l0)的联合
# loc_cond_prob[1][state]代表P(i0|d0, g1, s1, l0) = P(i0)，（因为i在定义中是第1个节点，且i不依赖于任何节点，所以state里其他节点的取值并不影响）
# loc_cond_prob[2][state]代表P(g1|d0, i0, s1, l0) = P(g1|d0, i0)，（因为g在定义中是第2个节点，且g只依赖于d和i）
loc_cond_prob = {}

loc_cond_prob[0] = np.zeros(size)
# 因为d与其他节点都无关，所以无论其他节点的值如何（用:表明不在意下标），loc_cond_prob[0][state]即为P(d0)
loc_cond_prob[0][0, :, :, :, :] = 0.6
loc_cond_prob[0][1, :, :, :, :] = 0.4

loc_cond_prob[1] = np.zeros(size)
loc_cond_prob[1][:, 0, :, :, :] = 0.7
loc_cond_prob[1][:, 1, :, :, :] = 0.3

loc_cond_prob[2] = np.zeros(size)
loc_cond_prob[2][0, 0, 0, :, :] = 0.3
loc_cond_prob[2][0, 0, 1, :, :] = 0.4
loc_cond_prob[2][0, 0, 2, :, :] = 0.3
loc_cond_prob[2][0, 1, 0, :, :] = 0.9
loc_cond_prob[2][0, 1, 1, :, :] = 0.08
loc_cond_prob[2][0, 1, 2, :, :] = 0.02
loc_cond_prob[2][1, 0, 0, :, :] = 0.05
loc_cond_prob[2][1, 0, 1, :, :] = 0.25
loc_cond_prob[2][1, 0, 2, :, :] = 0.7
loc_cond_prob[2][1, 1, 0, :, :] = 0.5
loc_cond_prob[2][1, 1, 1, :, :] = 0.3
loc_cond_prob[2][1, 1, 2, :, :] = 0.2

loc_cond_prob[3] = np.zeros(size)
loc_cond_prob[3][:, 0, :, 0, :] = 0.95
loc_cond_prob[3][:, 0, :, 1, :] = 0.05
loc_cond_prob[3][:, 1, :, 0, :] = 0.2
loc_cond_prob[3][:, 1, :, 1, :] = 0.8

loc_cond_prob[4] = np.zeros(size)
loc_cond_prob[4][:, :, 0, :, 0] = 0.1
loc_cond_prob[4][:, :, 0, :, 1] = 0.9
loc_cond_prob[4][:, :, 1, :, 0] = 0.4
loc_cond_prob[4][:, :, 1, :, 1] = 0.6
loc_cond_prob[4][:, :, 2, :, 0] = 0.99
loc_cond_prob[4][:, :, 2, :, 1] = 0.01
"""
TODO 1:
    请编写合理的代码段，根据作业给出的贝叶斯网络图定义loc_cond_prob[3]和loc_cond_prob[4]。
NOTE:
    参考loc_cond_prob[0]~[2]的写法。
"""


# ******************************** Generate Joint Probabilities ******************************** #
class BayesianNetwork:
    def __init__(self, size: Tuple, loc_cond_prob: Dict) -> None:
        self.size = size
        self.loc_cond_prob = loc_cond_prob

        self.joint_states = {}  # self.joint_states[i]为第i个state，定义下标i方便后续直接取出state值
        self.state_num = 0  # 记录在该贝叶斯网络中一共有多少个state
        self.cur_state = [0] * len(self.size)  # 初始化state, [0,0,0,0,0]
        self.enumarate_joint_states(0)  # 从第0个节点开始枚举，一直到最后一个节点，每个节点的不同属性值都会被没举出来

        self.joint_prob = np.ones(size)  # self.joint_prob[state]即为P(state)
        self.cal_joint_prob()

    def enumarate_joint_states(self, start_idx: int) -> None:
        """
        枚举所有可能的state，即(0, 0, 0, 0, 0), (0, 0, 0, 0, 1), ..., (1, 1, 1, 1, 1)
        """
        if start_idx == len(self.size):
            self.joint_states[self.state_num] = tuple(self.cur_state)
            self.state_num += 1
            return

        for val in range(self.size[start_idx]):
            self.cur_state[start_idx] = val
            self.enumarate_joint_states(start_idx + 1)

    def cal_joint_prob(self) -> None:
        """
        计算每个state对应的联合分布的概率
        """
        for idx in range(len(self.size)):
            for state in self.joint_states.values():
                if idx == 0:
                    # 若idx = 0，则联合概率就是最初的条件概率
                    self.joint_prob[state] = self.loc_cond_prob[idx][state]
                else:
                    self.joint_prob[state] = self.joint_prob[state] * self.loc_cond_prob[idx][state]

                """
                TODO 2:
                    请编写合理的代码段，从而正确地计算出联合分布概率。
                NOTE:
                    在定义好的节点顺序，不会出现前面的节点依赖于后续节点的情况，
                    所以可以通过当前的self.joint_prob与对应的self.loc_cond_prob相乘来得到state中前idx+1个节点的联合分布概率。
                    eg. state=(0, 0, 1, 1, 0)代表了(d0, i0, g1, s1, l0)的联合，
                    则idx=2时self.joint_prob[state]=P(d0, i0, g1)=P(d0, i0)*P(g1|d0, i0)，
                    其中P(d0, i0)为idx=1时得到的self.joint_prob[state]，P(g1|d0, i0)为self.loc_cond_prob[idx][state]
                    当遍历完最后一个节点，self.joint_prob就是所有节点的联合分布概率。
                """

    def prob_map_joint(self) -> np.array:
        """
        将所有state的概率映射到[0, 1]上，即概率分布函数
        eg. 一共有3个state，state_0, state_1, state_2出现的概率分别为0.2, 0.5, 0.3，
        则返回sample_prob=[0.2, 0.7, 1]，
        若生成服从0-1均匀分布随机数0.34，因为0.2<0.34<0.7，所以对应state_1
        """
        sample_prob = np.zeros((len(self.joint_states)))
        for i, state in enumerate(self.joint_states.values()):
            if i == 0:
                sample_prob[i] = self.joint_prob[state]
            else:
                sample_prob[i] = self.joint_prob[state] + sample_prob[i - 1]
        return sample_prob

    def prob_map_cond(self, idx: int, cur_state: List, prob: Dict) -> np.array:
        """
        原理同prob_map_joint
        这里是对于所有的state，而是针对第idx个节点与给定的cur_state，计算其他节点值固定时第idx个节点取不同值的条件概率，
        将其条件概率映射到[0, 1]上，即概率分布函数
        """
        sample_prob = np.zeros((self.size[idx]))
        for val in range(self.size[idx]):
            cur_state[idx] = val
            if val == 0:
                sample_prob[val] = prob[idx][tuple(cur_state)]
            else:
                sample_prob[val] = prob[idx][tuple(cur_state)] + sample_prob[val - 1]

        return sample_prob
