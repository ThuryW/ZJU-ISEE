import torch
import time
import argparse
from models import MultiHeadedAttention1, MultiHeadedAttention2


def cal_error(a, b, thresh):
    # 计算张量a和b的相对误差(b-a)<thresh的比例
    ratio = (torch.abs(a - b) < thresh).float().mean().data

    return ratio


def output_and_gradient_check():
    mhsa1 = MultiHeadedAttention1(head_num=8, d_model=256, dropout_layer=None)
    mhsa2 = MultiHeadedAttention2(head_num=8, d_model=256, dropout_layer=None)

    d_model = 256
    head_num = 8

    # 用随机数初始化几个linear_project层
    linear_project_query1 = [0] * head_num
    linear_project_key1 = [0] * head_num
    linear_project_value1 = [0] * head_num
    for i in range(head_num):
        linear_project_query1[i] = torch.rand((d_model // head_num, d_model))
        linear_project_key1[i] = torch.rand((d_model // head_num, d_model))
        linear_project_value1[i] = torch.rand((d_model // head_num, d_model))
    linear_project_query2 = torch.concat(linear_project_query1, dim=0)
    linear_project_key2 = torch.concat(linear_project_key1, dim=0)
    linear_project_value2 = torch.concat(linear_project_value1, dim=0)
    final_linear_project = torch.rand((d_model, d_model))
    # 将相同的参数赋给mhsa1和mhsa2以比较
    with torch.no_grad():
        for i in range(head_num):
            mhsa1.linear_project_query[i].weight.set_(linear_project_query1[i])
            mhsa1.linear_project_query[i].bias.fill_(0)
            mhsa1.linear_project_key[i].weight.set_(linear_project_key1[i])
            mhsa1.linear_project_key[i].bias.fill_(0)
            mhsa1.linear_project_value[i].weight.set_(linear_project_value1[i])
            mhsa1.linear_project_value[i].bias.fill_(0)
        mhsa1.final_linear_project.weight.set_(final_linear_project)
        mhsa1.final_linear_project.bias.fill_(0)

        mhsa2.linear_project_query.weight.set_(linear_project_query2)
        mhsa2.linear_project_query.bias.fill_(0)
        mhsa2.linear_project_key.weight.set_(linear_project_key2)
        mhsa2.linear_project_key.bias.fill_(0)
        mhsa2.linear_project_value.weight.set_(linear_project_value2)
        mhsa2.linear_project_value.bias.fill_(0)
        mhsa2.final_linear_project.weight.set_(final_linear_project)
        mhsa2.final_linear_project.bias.fill_(0)

    # 产生随机的输入query、key、value、mask
    size = (16, 49, 256)
    query = torch.rand(size, requires_grad=True)
    key = torch.rand(size, requires_grad=True)
    value = torch.rand(size, requires_grad=True)
    mask_num = int(torch.rand(1) * size[1])
    mask = torch.concat([torch.zeros((size[0], 1, size[1] - mask_num)), torch.ones((size[0], 1, mask_num))], dim=2)
    # 比较output是否相同
    output1 = mhsa1(query, key, value, mask)
    output2 = mhsa2(query, key, value, mask)
    thresh = 1e-4
    print('output same rate: {:.2f}%'.format(cal_error(output1, output2, thresh) * 100))
    # 比较query、key、value的梯度是否相同
    output_gradients = torch.rand_like(output1)
    grad1 = torch.autograd.grad(output1, query, output_gradients, retain_graph=True)
    grad2 = torch.autograd.grad(output2, query, output_gradients, retain_graph=True)
    print('query gradient same rate: {:.2f}%'.format(cal_error(grad1[0], grad2[0], thresh) * 100))
    grad1 = torch.autograd.grad(output1, key, output_gradients, retain_graph=True)
    grad2 = torch.autograd.grad(output2, key, output_gradients, retain_graph=True)
    print('key gradient same rate: {:.2f}%'.format(cal_error(grad1[0], grad2[0], thresh) * 100))
    grad1 = torch.autograd.grad(output1, value, output_gradients, retain_graph=True)
    grad2 = torch.autograd.grad(output2, value, output_gradients, retain_graph=True)
    print('value gradient same rate: {:.2f}%'.format(cal_error(grad1[0], grad2[0], thresh) * 100))


def time_compare(num=1000):
    # 测试两种mhsa实现的运行速度
    mhsa1 = MultiHeadedAttention1(head_num=8, d_model=256, dropout_layer=None)
    mhsa2 = MultiHeadedAttention2(head_num=8, d_model=256, dropout_layer=None)
    time1 = 0
    time2 = 0
    size = (16, 49, 256)

    for i in range(num):
        query = torch.rand(size)
        key = torch.rand(size)
        value = torch.rand(size)
        mask_num = int(torch.rand(1) * size[1])
        mask = torch.concat([torch.zeros((size[0], 1, size[1] - mask_num)), torch.ones((size[0], 1, mask_num))], dim=2)

        start_time = time.time()
        output1 = mhsa1(query, key, value, mask)
        end_time = time.time()
        time1 += end_time - start_time

        query = torch.rand(size)
        key = torch.rand(size)
        value = torch.rand(size)
        mask_num = int(torch.rand(1) * size[1])
        mask = torch.concat([torch.zeros((size[0], 1, size[1] - mask_num)), torch.ones((size[0], 1, mask_num))], dim=2)

        start_time = time.time()
        output2 = mhsa2(query, key, value, mask)
        end_time = time.time()
        time2 += end_time - start_time

    print('for循环计算mhsa用时: {:.2f}ms, pytorch矩阵并行计算mhsa用时: {:.2f}ms'.format(time1 / num * 1000, time2 / num * 1000))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='mhsa_parallel_check')
    parser.add_argument('--function', default='time_comp', type=str, help='check or time_comp')
    args = parser.parse_args()
    if args.function == 'check':
        output_and_gradient_check()
    elif args.function == 'time_comp':
        time_compare(num=1000)  # 设置for循环重复次数


