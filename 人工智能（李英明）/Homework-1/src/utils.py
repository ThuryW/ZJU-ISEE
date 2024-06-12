import copy
from typing import List, Literal, Tuple
from collections import deque


# ******************************** State of Board ******************************** #
class State(object):
    """
    class State :: Records the state of the board, and provides some useful tools.

    Methods ::
        - print :: print the board in a pretty style.

    Example ::
        >>> state = State(((1, 2, 3), (4, 5, 6), (7, 8, 0)))
        >>> state.board
        ((1, 2, 3), (4, 5, 6), (7, 8, 0))
        >>> state.board_list
        [[1, 2, 3], [4, 5, 6], [7, 8, 0]]
        >>> state.print()
        1 2 3
        4 5 6
        7 8 0
    """

    def __init__(self, board: Tuple[Tuple[int]]):
        """
        Construct state from tuple of int.
        Args ::
            - board :: 3x3 tuple of int, each entry should be unique and integers greater or equal to 0 and less than 9.
        """
        self.board = board
        self.board_list = list(list(x) for x in board)  # convert tuple to list
        self.blank_loc = None
        for i in range(3):
            for j in range(3):
                if board[i][j] == 0:
                    self.blank_loc = (i, j)

        assert self.blank_loc is not None, "invalid input!"

    def print(self) -> None:
        for i in range(3):
            print(' '.join([f'{x}' for x in self.board[i]]))


# ******************************** Search ******************************** #
class Move(object):
    """
    Define the moves of the board.

    Example ::
        >>> state = State(((1, 2, 3), (4, 5, 6), (7, 8, 0)))
        >>> state.print()
        1 2 3
        4 5 6
        7 8 0
        >>> up = Move('U', 5)
        >>> new_state, cost = up(state)
        >>> new_state.print()
        1 2 3
        4 5 0
        7 8 6
        >>> cost
        5
        >>> right = Move('R', 2)
        >>> right(state)
        None
    """
    dir_dict = {'L': (0, -1), 'R': (0, 1), 'U': (-1, 0), 'D': (1, 0)}

    def __init__(self, direction: str, cost: int = 1) -> None:
        """
        Args ::
            - direction :: str, should be 'L', 'R', 'U' or 'D', represents left, right, up or down, respectively.
            - cost :: int, corresponding cost to the direction
        """
        assert len(direction) == 1 and direction in 'LRUD'
        self.direction = self.dir_dict[direction]
        self.cost = cost

    def _move(self, state: State) -> Tuple[State, int]:
        # change numbers in board, therefore use list (mutable data type)
        board_list = copy.deepcopy(state.board_list)
        loc = state.blank_loc
        new_loc = (self.direction[0] + loc[0], self.direction[1] + loc[1])
        if 0 <= new_loc[0] < 3 and 0 <= new_loc[1] < 3:  # exchange the blank and the target number
            board_list[loc[0]][loc[1]] = board_list[new_loc[0]][new_loc[1]]
            board_list[new_loc[0]][new_loc[1]] = 0
        else:
            return None
        return State(tuple(tuple(x) for x in board_list)), self.cost

    def __call__(self, state: State) -> Tuple[State, int]:
        """
        Move the blank towards the direction for one step.
        If blank is out of the board, return None.
        Otherwise, return the new state after move.
        """
        return self._move(state)


class Search(object):
    def __init__(self, init_state: State, goal_state: State, move_type: int = 1):
        """
        Args ::
            - init_state :: State, the initial state of board
            - goal_state :: State, the goal state of board
            - move_type :: int, define different move costs corresponding to move actions
        """
        self.init_state = State(init_state.board)
        self.goal_state = State(goal_state.board)
        if move_type == 1:
            self.moves = [Move(d) for d in 'LRUD']  # cost is 1 for each direction
        else:
            self.moves = [Move(d, c) for d, c in zip("LRUD", [1, 1, 5, 5])]  # newly defined cost
        self.reset()  # some initialization operations

    def reset(self) -> None:
        self.stats = {
            'n_explored': 0,        # the number of explored states
            'max_size': 0,          # the max number of states in the open_set at any time
            'cost': 0,              # the cost to reach goal state from initial state
        }
        self.path = []              # path from init_state to goal_state
        self.done = False           # whether the search process is over
        self.no_solution = False    # whether there is no feasible solution
        self.visited = dict()       # record states that have been visited, and self.visited[n] is the cost to reach state n from init_state
        self.came_from = dict()     # record states along the exploration path, and self.came_from[n] is the state previous to state n

    def solve(self) -> None:  # to be implemented according to different search algorithm in corresponding class
        raise NotImplementedError

    def check_init_state(self) -> bool:
        # check if init_state is already goal_state
        if self.init_state.board == self.goal_state.board:
            self.path = [self.init_state]
            self.done = True
            return True
        else:
            self.came_from[self.init_state.board] = None
            self.visited[self.init_state.board] = 0
            return False

    def check_new_state(self, cur_state: State, cur_cost: int, new_state: State, move_cost: int) -> (bool, int):
        """
        this function checks if the new_state is goal_state and process it accordingly
        """
        
        new_cost = cur_cost + move_cost     # new_cost记录到达新状态所需的cost
        self.came_from[new_state.board] = cur_state     #记录新状态的上一状态，即当前状态
        self.visited[new_state.board] = new_cost        #记录到达新状态所需要的cost
        """
        TODO 1:
            请用合理的表达式替换上面代码段中的'x_x','+_+'和'=_='，
            使得这段代码可以正确处理new_state。
        NOTE:
            new_state为cur_state经过一步移动得到的状态，
            move_cost为从cur_state移动到new_state所需要的cost。
        """

        if new_state.board == self.goal_state.board:  # reach the goal_state
            self.stats['cost'] = new_cost  # record the total cost
            self.backtrack(new_state)  # generate path from init_state to goal_state
            self.done = True
            return True, 0
        else:
            return False, new_cost

    def backtrack(self, cur_state: State) -> None:
        """
        this fuction backtracks to the initial state through came_from and construct the solution path
        """
        # 思路：先添加当前状态，当未达到init_state时，再添加上一状态，最后达到init_state后停止添加并反转列表
        
        self.path.append(cur_state) # 添加当前状态
        if self.came_from[cur_state.board] != None:  # 当self.came_from[cur_state.board] != None时说明当前状态尚为达到init_state
            self.path.append(self.came_from[cur_state.board])
            self.backtrack(self.came_from[cur_state.board])
        else:  #self.came_from[cur_state.board] == None，说明已经达到init_state，此时停止添加并反转列表
            self.path.reverse()

        """
        TODO 2:
            请编写合理的代码段。
            这部分代码将构建从init_state到cur_state的状态路径，即[init_state, state_1, ..., state_n, cur_state]，
            并将路径保存在self.path（list数据类型）中。
        NOTE:
            self.came_from字典中包含了路径信息，即当前状态是从哪个状态移动过来的。
            在回溯到init_state后将self.path中的状态顺序反转即可。
        """

    def print(self) -> None:
        if not self.done:
            print("Search is not done, nothing to output")
            return

        if self.no_solution:
            print("No Solution!")
            return

        for i, state in enumerate(self.path):
            print(f"Step {i}")
            state.print()
            print()
        print('----------')
        print("Stats Info: ")
        for key, value in self.stats.items():
            print(f'{key}: {value}')


# ******************************** Data Structure: Queue & PriorityQueue ******************************** #

class Queue(object):
    def __init__(self) -> None:
        self._queue = deque()

    def size(self) -> int:
        """
        Number of elements in queue
        """
        return len(self._queue)

    def push(self, item) -> None:
        """
        Push operation
        """
        self._queue.append(item)

    def pop(self):
        """
        Pop operation
        """
        return self._queue.popleft()

    def empty(self) -> bool:
        """
        Test if the queue is empty
        """
        return len(self._queue) == 0


class PriorityQueue(object):
    """
    A priority queue, implemented via a minheap.

    Methods ::
        - push :: (item: Literal, priority: int) -> None,
            Input an item (hashable), and its priority.
            - If the item is already in queue, update its priority.
            - If the item is not in queue, insert the item with its priority.
        - pop :: () -> item: Literal,
            Return the item of the lowest priority in the queue.
        - empty :: () -> bool
            Return if the queue is empty.
        - size :: () -> int
            Return the size of queue.

    Example ::
        >>> Q = PriorityQueue()
        >>> Q.push('a', 1)
        >>> Q.empty()
        False
        >>> Q.push('b', 2)
        >>> Q.push('c', 4)
        >>> Q.size()
        3
        >>> Q.pop()
        'a'
        >>> Q.push('c', 0)
        >>> Q.pop()
        'c'
        >>> Q.pop()
        'b'
        >>> Q.empty()
        True
    """

    def __init__(self) -> None:
        self._elements = [None]  # the actual element index start from 1
        self._mapping = dict()

    def _swap(self, id1, id2):
        if id1 == id2:
            return
        # swap elements
        t = self._elements[id1]
        self._elements[id1] = self._elements[id2]
        self._elements[id2] = t
        # update mapping info
        self._mapping[self._elements[id1][1]] = id1
        self._mapping[self._elements[id2][1]] = id2

    def _upward(self, idx):
        pri, _ = self._elements[idx]
        while idx > 1:
            prev = idx >> 1
            if self._elements[prev][0] > pri:
                self._swap(prev, idx)
            else:
                break
            idx = prev
        return idx

    def _downward(self, idx):
        pri, _ = self._elements[idx]
        size = self.size()
        while idx * 2 < size:
            if idx * 2 + 1 < size:
                left_idx = idx * 2
                right_idx = idx * 2 + 1
                min_idx = left_idx if self._elements[left_idx][0] < self._elements[right_idx][0] else right_idx
            else:
                min_idx = idx * 2

            if self._elements[min_idx][0] < pri:
                self._swap(min_idx, idx)
                idx = min_idx
            else:
                break

    def push(self, item: Literal, priority: int) -> None:
        """
        Push item with priority into queue.
        """
        if item not in self._mapping:
            self._elements.append((priority, item))
            idx = len(self._elements) - 1
            self._mapping[item] = idx
            self._upward(idx)
        else:
            # item is in queue
            idx = self._mapping[item]
            if priority < self._elements[idx][0]:
                # a smaller priority means the node can be reached with lower cost
                # therefore, update with this new priority
                self._elements[idx] = (priority, item)
                self._upward(idx)

    def pop(self) -> Literal:
        """
        Pop the item of the lowest priority.
        """
        assert not self.empty(), "Queue is empty!"
        last_idx = len(self._elements) - 1
        self._swap(1, last_idx)
        # clear the last element
        res = self._elements.pop()
        self._mapping.pop(res[1])

        if not self.empty():
            self._downward(1)
        return res[1]

    def empty(self) -> bool:
        """
        Test if the queue is empty.
        """
        return len(self._elements) == 1

    def size(self) -> int:
        """
        size of queue
        """
        return len(self._elements) - 1


# ******************************** Heuristic Function ******************************** #
def heuristic_func1(state: State, goal_state: State) -> int:
    """
    A heuristic function that calculates the max cost of moving corresponding number from
    the current state to the goal state.
    """
    mem = [None] * 9
    dist = 0
    for i in range(3):
        for j in range(3):
            mem[state.board[i][j]] = (i, j)

    for i in range(3):
        for j in range(3):
            cur_loc = mem[goal_state.board[i][j]]  # the location of number in current state
            dist = max(dist, abs(cur_loc[0] - i) * 5 + abs(cur_loc[1] - j))
    return dist


def heuristic_func2(state: State, goal_state: State) -> int:
    """
    TODO 3:
        请编写合理的代码段。
        这部分代码将实现你所设计的启发式函数。
    Note:
        返回一个整数，表明当前状态到目标状态的距离。
    """
    mem = [None] * 9
    dist = 0
    for i in range(3):
        for j in range(3):
            mem[state.board[i][j]] = (i, j)

    for i in range(3):
        for j in range(3):
            cur_loc = mem[goal_state.board[i][j]]  # the location of number in current state
            dist = max(dist, abs(cur_loc[0] - i) + abs(cur_loc[1] - j))  # 此处和heuristic_func1不同，这里取每个方向单位cost都是1
    return dist