from utils import State, Search, Move


class DepthFirstSearch(Search):
    def __init__(self, init_state: State, goal_state: State, move_type: int = 1):
        super().__init__(init_state, goal_state, move_type)

    def dfs(self, cur_state: State, cur_cost: int = 0, depth: int = 0) -> None:  # the recursive dfs function
        new_states = [move(cur_state) for move in self.moves]
        new_states = [n for n in new_states if n is not None and n[0].board not in self.visited]

        self.stats['n_explored'] += 1
        for new_state, move_cost in new_states:
            is_goal_state, _ = self.check_new_state(cur_state, cur_cost, new_state, move_cost)
            if is_goal_state:  # find goal_state
                return
            else:
                self.dfs(new_state, cur_cost + move_cost, depth + 1)
                # 递归到下一层深度，即调用自身处理new_state，找到结果后会return结束递归
                """
                TODO 10:
                    请用合理的参数替换'?_?'，使程序能够递归到下一搜索深度。
                """
                if self.done:  # any succeeding state is goal_state
                    return  # must exit the search process

    def solve(self) -> None:
        if self.check_init_state():  # Oh! We have found the goal_state!
            return
        # ******************** dfs begin ********************#
        self.dfs(self.init_state)
        # ******************** dfs begin ********************#
        self.no_solution = not self.done
        self.done = True


if __name__ == "__main__":
    init_state = State(((1, 2, 3),
                        (4, 5, 6),
                        (7, 8, 0)))
    goal_state = State(((7, 3, 1),
                        (8, 0, 4),
                        (6, 5, 2)))
    solver = DepthFirstSearch(init_state, goal_state, move_type=2)
    solver.solve()
    solver.print()
