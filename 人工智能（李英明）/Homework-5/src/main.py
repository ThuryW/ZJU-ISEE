# -*- coding: utf-8 -*-
import argparse
import os
import time
from models import LeNet5, LeNet4, MSELoss
import torch.nn as nn
import torch

import torch.optim as optim
from tqdm import tqdm
from utils import init_logger_writer, inform_logger_writer, close_logger_writer, data_loader, AvgMeter


def preparation(args):
    """
    根据命令行的参数设置相应的模型、损失函数、优化器、是否使用学习率调节器
    """
    # 初始化log和tensorboard实例
    logger, writer = init_logger_writer(args)

    # 获取模型
    if args.model == 'lenet4':
        model = LeNet4()
    elif args.model == 'lenet5':
        model = LeNet5()
    else:
        raise ValueError("Wrong model!")

    # 获取损失函数
    if args.criterion == 'cross_entropy':
        criterion = nn.CrossEntropyLoss()  # 交叉熵损失
    elif args.criterion == 'mse':
        criterion = MSELoss()  # 均方误差损失
    else:
        raise ValueError("Wrong criterion!")

    # 获取优化器，除了学习率，其他参数都使用对应优化器的默认值
    if args.optimizer == 'sgd':
        optimizer = optim.SGD(model.parameters(), lr=args.learning_rate)
    elif args.optimizer == 'adam':
        optimizer = optim.Adam(model.parameters(), lr=args.learning_rate)
    else:
        raise ValueError("Wrong optimizer!")

    # 设置scheduler（学习率调节器），如果不设置则训练过程中学习率一直为args.learning_rate
    # 若选择设置，如下给出了一种调节方式：总共max_num个epoch，第i个epoch的learning rate = (1-i/max_num)^0.9，
    # 即训练过程中学习率不断减小，使得训练后期的梯度变化逐渐稳定
    scheduler = None
    if args.use_scheduler:
        scheduler = optim.lr_scheduler.LambdaLR(optimizer, lr_lambda=lambda epoch: (1 - epoch / args.epochs) ** 0.9)

    return model, criterion, optimizer, scheduler, logger, writer


def train_process(args, train_loader, val_loader, model, criterion, optimizer, scheduler, logger, writer):
    """
    训练模型，并保存验证集上准确率最高的模型参数用于后续测验
    """
    best_acc = 0.  # 记录最好的验证集准确率
    time_list = [0] * 3  # 记录一个epoch里的开始时刻、训练完成时刻、验证完成时刻

    for epoch in range(args.epochs):
        # train part
        time_list[0] = time.time()
        loss_meter = AvgMeter()
        acc_meter = AvgMeter()
        if args.use_scheduler:  # 使用学习率调节器
            scheduler.step(epoch)
        for image_batch, gt_batch in tqdm(train_loader):  # 从训练集的dataloader里获取一个batch的image（输入图像）和gt（ground truth，真值标签）
            gt_batch = gt_batch.long()  # 真值标签类型转换为long，因为nn.CrossEntropyLoss()只接收该类型的输入
            # 模型预测->计算loss->后向传播
            pred_batch = model(image_batch)
            loss = criterion(pred_batch, gt_batch)
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()
            # 记录该batch的loss
            loss_meter.add(loss.item(), image_batch.size(0))
            # 计算accuracy为该batch中预测类别与真值类别相同的个数的均值
            acc = (pred_batch.argmax(dim=-1).long() == gt_batch).float().mean()
            acc_meter.add(acc.item(), image_batch.size(0))
        # 计算该epoch的训练loss和accuracy均值
        train_loss = loss_meter.avg()
        train_acc = acc_meter.avg()

        # validate part
        time_list[1] = time.time()
        loss_meter = AvgMeter()
        acc_meter = AvgMeter()
        for image_batch, gt_batch in tqdm(val_loader):
            gt_batch = gt_batch.long()
            with torch.no_grad():  # 由于验证阶段不需要后向传播梯度，所以用torch.no_grad()防止产生梯度
                pred_batch = model(image_batch)
                loss = criterion(pred_batch, gt_batch)
            loss_meter.add(loss.item(), image_batch.size(0))
            acc = (pred_batch.argmax(dim=-1).long() == gt_batch).float().mean()
            acc_meter.add(acc.item(), image_batch.size(0))
        val_loss = loss_meter.avg()
        val_acc = acc_meter.avg()

        time_list[2] = time.time()
        inform_logger_writer(logger, writer, epoch + 1, train_loss, val_loss, train_acc, val_acc, time_list)

        if acc_meter.avg() > best_acc:
            # 如果超过了当前的最好验证集准确率，则保存该模型参数
            best_acc = acc_meter.avg()
            if not os.path.exists(args.checkpoint_dir):
                os.makedirs(args.checkpoint_dir)
            torch.save(model.state_dict(), os.path.join(args.checkpoint_dir, 'best.pt'))
            print(f'Save best model @ Epoch {epoch + 1}')


def test_process(args, test_loader):
    """
    使用验证集上准确率最高的模型在测试集上进行测试
    """
    # 加载之前保存的模型参数
    model.load_state_dict(torch.load(os.path.join(args.checkpoint_dir, 'best.pt')))
    loss_meter = AvgMeter()
    acc_meter = AvgMeter()

    for image_batch, gt_batch in tqdm(test_loader):
        gt_batch = gt_batch.long()
        with torch.no_grad():
            pred_batch = model(image_batch)
            loss = criterion(pred_batch, gt_batch)
        loss_meter.add(loss.item(), image_batch.size(0))
        acc = (pred_batch.argmax(dim=-1).long() == gt_batch).float().mean()
        acc_meter.add(acc.item(), image_batch.size(0))
    test_loss = loss_meter.avg()
    test_acc = acc_meter.avg()

    return test_loss, test_acc


if __name__ == '__main__':
    start_time = time.time()
    parser = argparse.ArgumentParser(description='train process')
    parser.add_argument('--model', default='lenet4', type=str, help='lenet4 or lenet5')  # 模型
    parser.add_argument('--criterion', default='cross_entropy', type=str, help='cross_entropy or mse')  # 损失函数
    parser.add_argument('--learning_rate', default=1e-2, type=float)  # 初始学习率
    parser.add_argument('--optimizer', default='sgd', type=str, help='sgd or adam')  # 优化器
    parser.add_argument('--use_scheduler', action='store_true', help='use learning rate scheduler')  # 是否使用学习率调节器
    parser.add_argument('--batch_size', default=128, type=int)
    parser.add_argument('--epochs', default=10, type=int)
    parser.add_argument('--checkpoint_dir', default='./checkpoint', type=str, help='the directory to save checkpoint')
    args = parser.parse_args()

    train_loader, val_loader, test_loader = data_loader(batch_size=args.batch_size)  # 产生dataloader
    model, criterion, optimizer, scheduler, logger, writer = preparation(args)  # 获取训练所需要的各种实例
    train_process(args, train_loader, val_loader, model, criterion, optimizer, scheduler, logger, writer)  # 训练和验证
    test_loss, test_acc = test_process(args, test_loader)  # 测试
    close_logger_writer(logger, writer, start_time, test_loss, test_acc)  # 关闭log和tensorboard实例
