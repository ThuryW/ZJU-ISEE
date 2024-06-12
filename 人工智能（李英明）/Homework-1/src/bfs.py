from utils import State, Search, Move
from utils import Queue


class BreadthFirstSearch(Search):
    def __init__(self, init_state: State, goal_state: State, move_type: int = 1):
        super().__init__(init_state, goal_state, move_type)

    def solve(self) -> None:
        if self.check_init_state():  # Oh! We have found the goal_state!
            return
        # ******************** bfs begin ********************#
        open_set = Queue()
        open_set.push(self.init_state)

        while not open_set.empty():
            cur_state = open_set.pop()
            cur_cost = self.visited[cur_state.board]

            new_states = [move(cur_state) for move in self.moves]
            new_states = [n for n in new_states
                         if n is not None and n[0].board not in self.visited] # n为新状态，该语句表示新状态不为None且是未访问的
            """
            TODO 4:
                请用合理的表达式替换'x_x'，使得这行代码能够过滤掉访问过的状态。
            NOTE:
                move(state)返回的结果为None，或者(state, cost)，
                其中state为node经过move后的状态，cost为该move的代价。
                当node不能进行该move时，结果为None。
            """
            
            self.stats['n_explored'] += 1
            for new_state, move_cost in new_states:
                is_goal_state, _ = self.check_new_state(cur_state, cur_cost, new_state, move_cost)
                if is_goal_state:
                    return
                else:
                    open_set.push(new_state)
                    """
                    TODO 5:
                        请用合理的表达式替换'+_+'，使得新访问的状态能够被正确添加到open_set中。
                    """
            self.stats['max_size'] = max(self.stats['max_size'], open_set.size())
        # ******************** bfs end ********************#
        # open_set is empty, so there is no feasible solution
        self.done = True
        self.no_solution = True


if __name__ == "__main__":
    init_state = State(((1, 2, 3),
                        (4, 5, 6),
                        (7, 8, 0)))
    goal_state = State(((7, 3, 1),
                        (8, 0, 4),
                        (6, 5, 2)))
    solver = BreadthFirstSearch(init_state, goal_state, move_type=2)
    solver.solve()
    solver.print()
