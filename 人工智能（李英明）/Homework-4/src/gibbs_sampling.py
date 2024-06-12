import numpy as np
from typing import Tuple, List, Dict
from tqdm import tqdm
from utils import BayesianNetwork, size, loc_cond_prob


class GibbsSampling(BayesianNetwork):
    def __init__(self, size: Tuple, loc_cond_prob: Dict) -> None:
        super(GibbsSampling, self).__init__(size, loc_cond_prob)
        self.cond_prob = {}
        self.cal_cond_prob()

    def cal_cond_prob(self):
        """
        通过local conditional probability计算conditional probability
        eg. state=(0, 0, 1, 1, 0)代表了(d0, i0, g1, s1, l0)的联合
        self.cond_prob[1][state]代表了P(i0|d0, g1, s1, l0)
        注意区分cond_prob和loc_cond_prob的不同
        """
        for i in range(len(self.size)):
            s = self.joint_prob.sum(axis=i, keepdims=True) # 去掉目标节点的维度
            """
            TODO 9:
                请用合理的表达式替换'x_x'，正确计算其他节点已知时的概率。
            NOTE:
                将目标节点从联合分布中消除即可。
            """
            s = np.where(s == 0, 1, s)  # 将s中为0的值替换成1，防止除0报错
            self.cond_prob[i] = self.joint_prob / s  # 对目标节点所处条件概率进行归一化

    def sampling(self, initial_state: List, sample_round: int, target_idx: int, evidence_idxs: List) -> np.array:
        """
        :param initial_state: 除evidence的属性值固定外，随机定义其他节点的属性值，得到一个初始state
        :param sample_round: 采样轮数
        :param target_idx: 查询节点的下标
        :param evidence_idxs: evidence的下标
        """
        cur_state = initial_state
        counts = np.zeros((self.size[target_idx]))
        for _ in tqdm(range(sample_round)):
            for idx in range(len(self.size)):
                if idx not in evidence_idxs:
                    # 当idx不在evidence里面，才有采样的意义
                    """
                    TODO 10:
                        请用合理的表达式替换'>_<'，使其符合吉布斯采样的逻辑。
                    """
                    sample_prob = self.prob_map_cond(idx, cur_state, self.cond_prob) #根据吉布斯采样的定义，这里需要用cond_prob
                    """
                    TODO 11:
                        请用合理的参数替换'0_0'，计算出正确的sample_prob概率数组。
                    """
                    random_num = np.random.rand()  # 生成服从0-1均匀分布的随机数
                    new_val = np.where(sample_prob >= random_num)[0][0]
                    cur_state[idx] = new_val  # 更新cur_state中第idx个节点的值
                    counts[cur_state[target_idx]] += 1
                    """
                    TODO 12:
                        请用合理的表达式替换'=_='和'?_?'，使counts数组能够正确加上对应的次数。
                    """

        return counts / counts.sum()


if __name__ == "__main__":
    sample_method = GibbsSampling(size, loc_cond_prob)
    initial_state = [[0, 0, 0, 0, 0], [0, 0, 2, 1, 0], [0, 1, 0, 1, 0]] #与TODO 8相同
    """
    TODO 13:
        请用合理的表达式替换'x_x'，即自行定义各个查询中的initial_state，使其与给定evidence相符。
    NOTE:
        可以和TODO 8设置的一样。
    """
    target_idx = [4, 0, 2]
    evidence_idxs = [[0, 1], [2, 3], [1, 3, 4]]
    for i in range(3):
        result = sample_method.sampling(initial_state=initial_state[i],
                                        sample_round=100000,
                                        target_idx=target_idx[i],
                                        evidence_idxs=evidence_idxs[i])
        print(result)
