from utils import State, Search, Move
from utils import PriorityQueue


class UniformCostSearch(Search):
    def __init__(self, init_state: State, goal_state: State, move_type: int = 1):
        super().__init__(init_state, goal_state, move_type)

    def solve(self) -> None:
        if self.check_init_state():  # Oh! We have found the goal_state!
            return
        # ******************** ucs begin ********************#
        open_set = PriorityQueue()
        open_set.push(self.init_state.board, 0)

        while not open_set.empty():
            cur_state = State(open_set.pop())
            cur_cost = self.visited[cur_state.board]

            new_states = [move(cur_state) for move in self.moves]
            new_states = [n for n in new_states
                         if n is not None and ((n[0].board not in self.visited) or (n[0].board in self.visited and (cur_cost + n[1]) < self.visited[n[0].board]))]
                         # 判断新路径需要n不为None，且n为未访问或访问过但是cost更少的路径
                         # 新cost的计算：到达cur_state的cost加上从cur_state到new_state的cost
            """
            TODO 6:
                请用合理的表达式替换'x_x'。
            NOTE:
                在UCS算法中，如果遇到了已经访问的状态，还需要计算新的拓展路径与原来相比是否能够减少cost。
            """

            self.stats['n_explored'] += 1
            for new_state, move_cost in new_states:
                is_goal_state, new_cost = self.check_new_state(cur_state, cur_cost, new_state, move_cost)
                if is_goal_state:
                    return
                else:
                    open_set.push(new_state.board, new_cost) 
                    # 用每个状态的cost标记优先级，确保每次pop出来的都是cost最小的节点
                    # 如果新状态未访问过，则会加入到open_set当中；如果访问过则会更新对应的优先级(即cost)
                    """
                    TODO 7:
                        请用合理的表达式替换'+_+'，使得新访问的状态能够被正确添加到open_set中。
                    NOTE:
                        open_set为优先队列，'+_+'对应于new_node的优先级。
                    """
            self.stats['max_size'] = max(self.stats['max_size'], open_set.size())
        # ******************** ucs end ********************#
        self.no_solution = True
        self.done = True


if __name__ == "__main__":
    init_state = State(((1, 2, 3),
                        (4, 5, 6),
                        (7, 8, 0)))
    goal_state = State(((7, 3, 1),
                        (8, 0, 4),
                        (6, 5, 2)))
    solver = UniformCostSearch(init_state, goal_state, move_type=2)
    solver.solve()
    solver.print()
