import numpy as np
from typing import Tuple, List, Dict
from tqdm import tqdm
from utils import BayesianNetwork, size, loc_cond_prob


class RejectionSampling(BayesianNetwork):
    def __init__(self, size: Tuple, loc_cond_prob: Dict) -> None:
        super(RejectionSampling, self).__init__(size, loc_cond_prob)

    def sampling(self, sample_round: int, target_idx: int, evidences: Dict) -> np.array:
        """
        :param sample_round: 采样轮数
        :param target_idx: 查询节点的下标
        :param evidences: 字典，其中key为evidence的下标，value为对应的属性值
        """
        counts = np.zeros((self.size[target_idx]))
        sample_prob = self.prob_map_joint()
        for _ in tqdm(range(sample_round)):
            random_num = np.random.rand()  # 生成服从0-1均匀分布的随机数
            state_idx = np.where(sample_prob >= random_num)[0][0]
            cur_state = self.joint_states[state_idx]
            reject_flag = False  # reject_flag为True时代表该state被拒绝
            
            # 当采样生成的state不满足evidence，拒绝该state
            for idx in evidences.keys():
                if cur_state[idx] != evidences[idx]:
                    reject_flag = True

            """
            TODO 3:
                请编写合理的代码段，从而正确地设置reject_flag以拒绝不符合要求的state。
            NOTE:
                cur_state[idx]=v_idx表明在当前采样生成的state中第idx个节点的值为v_idx。
                evidences[idx]=v_idx表明第idx个节点是evidence，且它的值固定为v_idx。
            """

            if not reject_flag:
                # 每次未被拒绝的采样，都需要给目标节点的对应取值（即cur_state[target_idx]）加1
                counts[cur_state[target_idx]] += 1
                """
                TODO 4:
                    请用合理的表达式替换'=_='和'?_?'，使counts数组能够正确加上对应的次数。
                NOTE:
                    counts[i]代表了目标节点取值为i的次数。
                """

        return counts / counts.sum()  # normalize count


if __name__ == "__main__":
    sample_method = RejectionSampling(size, loc_cond_prob)
    target_idx = [4, 0, 2]
    evidences = [{0: 0, 1: 0}, {2: 2, 3: 1}, {1: 1, 3: 1, 4: 0}]
    for i in range(3):
        result = sample_method.sampling(sample_round=100000,
                                        target_idx=target_idx[i],
                                        evidences=evidences[i])
        print(result)
