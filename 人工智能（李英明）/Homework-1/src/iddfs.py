from utils import State, Search, Move


class IterativeDeepeningDepthFirstSearch(Search):
    def __init__(self, init_state: State, goal_state: State, move_type: int = 1):
        super().__init__(init_state, goal_state, move_type)

    def dfs(self, cur_state: State, cur_cost: int = 0, depth: int = 0, max_depth: int = 0) -> None:  # max_depth为设定的最大搜索深度
        """
        TODO 11:
            请编写合理的代码段。
            当下一层深度超过设定的最大深度时，这部分代码将结束搜索。
        """
        # 当该层深度等于最大深度，即下一层深度超过设定的最大深度时，这部分代码将结束搜索。
        if depth == max_depth:
            return

        new_states = [move(cur_state) for move in self.moves]
        new_states = [n for n in new_states if n is not None and n[0].board not in self.visited]

        self.stats['n_explored'] += 1
        for new_state, move_cost in new_states:
            is_goal_state, new_cost = self.check_new_state(cur_state, cur_cost, new_state, move_cost)
            if is_goal_state:  # find goal_state
                return
            else:
                self.dfs(new_state, new_cost, depth + 1, max_depth)
                # 递归，调用自身进入下一深度(depth + 1)
                """
                TODO 12:
                    请用合理的参数替换'?_?'，使程序能够递归到下一搜索深度。
                """
                if self.done:  # any succeeding state is goal_state
                    return  # must exit the search process

    def solve(self) -> None:
        if self.check_init_state():  # Oh! We have found the goal_state!
            return
        # ******************** iterative deepening dfs begin ********************#
        for max_depth in range(181400):  # maximum 9!/2 states
            
            self.reset() # 先对该search进行reset
            self.came_from[self.init_state.board] = None # 对came_from进行初始化
            self.visited[self.init_state.board] = 0 # 对visited进行初始化
            self.dfs(self.init_state, 0, 0, max_depth) #调用上面的dfs，并给出最大深度设置
            """
            TODO 13:
                请编写合理的代码段。
                这部分代码能够在重新设定max_depth时成功初始化每次搜索，并且调用dfs方法开启搜索。
            Note:
                参考Search父类中的reset()方法，并且重新使用init_state来初始化came_from和visited。
            """
            if self.done:
                break
        # ******************** iterative deepening dfs begin ********************#
        self.no_solution = not self.done
        self.done = True


if __name__ == "__main__":
    init_state = State(((1, 2, 3),
                        (4, 5, 6),
                        (7, 8, 0)))
    goal_state = State(((7, 3, 1),
                        (8, 0, 4),
                        (6, 5, 2)))
    solver = IterativeDeepeningDepthFirstSearch(init_state, goal_state, move_type=2)
    solver.solve()
    solver.print()
