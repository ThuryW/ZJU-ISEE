import numpy as np
from typing import Tuple, List, Dict
from tqdm import tqdm
from utils import BayesianNetwork, size, loc_cond_prob


class LikelihoodWeighting(BayesianNetwork):
    def __init__(self, size: Tuple, loc_cond_prob: Dict) -> None:
        super(LikelihoodWeighting, self).__init__(size, loc_cond_prob)

    def sampling(self, initial_state: List, sample_round: int, target_idx: int, evidence_idxs: List) -> np.array:
        """
        :param initial_state: 除evidence的属性值固定外，随机定义其他节点的属性值，得到一个初始state
        :param sample_round: 采样轮数
        :param target_idx: 查询节点的下标
        :param evidence_idxs: evidence的下标
        """
        counts = np.zeros((self.size[target_idx]))
        for _ in tqdm(range(sample_round)):
            w = 1
            cur_state = initial_state
            for idx in range(len(self.size)):
                if idx in evidence_idxs:
                    # w即权重，因为要考虑父节点的取值，其实就是条件概率，直接调用loc_cond_prob即可
                    w = w * loc_cond_prob[idx][tuple(cur_state)]
                    """
                    TODO 5:
                        编写合理的代码段，计算w。
                    NOTE:
                        w = w * P(第idx个节点=cur_state中它的值|cur_state中第idx个节点的parents)
                    """
                else:
                    sample_prob = self.prob_map_cond(idx, cur_state, loc_cond_prob)
                    """
                    TODO 6:
                        请用合理的参数替换'0_0'，计算出正确的sample_prob概率数组。
                    """
                    random_num = np.random.rand()  # 生成服从0-1均匀分布的随机数
                    new_val = np.where(sample_prob >= random_num)[0][0]  # 找到采样对应的值
                    cur_state[idx] = new_val  # 更新cur_state中第idx个节点的值
            counts[cur_state[target_idx]] += w #这里需要考虑权重，不能+1，应该+w
            """
            TODO 7:
                请用合理的表达式替换'=_='和'?_?'，使counts数组能够正确加上对应的次数。
            """

        return counts / counts.sum()


if __name__ == "__main__":
    sample_method = LikelihoodWeighting(size, loc_cond_prob)
    
    # 为了统一起见，evidence设置成和拒绝采样情况一样，其他节点取值随意，这里均设为0
    initial_state = [[0, 0, 0, 0, 0], [0, 0, 2, 1, 0], [0, 1, 0, 1, 0]] 
    """
    TODO 8:
        请用合理的表达式替换'x_x'，即自行定义各个查询中的initial_state，使其与给定evidence相符。
    """
    target_idx = [4, 0, 2]
    evidence_idxs = [[0, 1], [2, 3], [1, 3, 4]]
    for i in range(3):
        result = sample_method.sampling(initial_state=initial_state[i],
                                        sample_round=100000,
                                        target_idx=target_idx[i],
                                        evidence_idxs=evidence_idxs[i])
        print(result)
