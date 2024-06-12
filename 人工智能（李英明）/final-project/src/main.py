# -*- coding: utf-8 -*-
import argparse
import os
import time
import torch.nn.functional as F
import torch
from tqdm import tqdm
from transformers import AdamW

from models import pure_transformer
from utils import init_logger_writer, inform_logger_writer, close_logger_writer, AvgMeter
from datasets import data_loader


def preparation(args):
    """
    根据命令行的参数设置相应的模型、损失函数、优化器、是否使用学习率调节器
    """
    # 初始化log和tensorboard实例
    logger, writer = init_logger_writer(args)

    # 获取模型
    model = pure_transformer(layer_num=args.layer_num, dropout_prob=args.dropout_prob)

    # 获取优化器
    optimizer = AdamW(model.parameters(), lr=args.learning_rate)

    return model, optimizer, logger, writer


def train_process(args, train_loader, val_loader, model, optimizer, logger, writer):
    """
    训练模型，并保存验证集上准确率最高的模型参数用于后续测验
    """
    best_acc = 0.  # 记录最好的验证集准确率
    time_list = [0] * 3  # 记录一个epoch里的开始时刻、训练完成时刻、验证完成时刻

    for epoch in range(args.epochs):
        # train part
        time_list[0] = time.time()
        model.train()  # 用.train()使模型进入训练模式
        loss_meter = AvgMeter()
        acc_meter = AvgMeter()
        for input_ids, labels, mask_ids in tqdm(train_loader):
            # 模型预测->计算loss->后向传播
            pred = model(input_ids, mask_ids)
            loss = F.cross_entropy(pred, labels)  # 交叉熵损失
            optimizer.zero_grad()
            loss.backward()
            torch.nn.utils.clip_grad_norm_(model.parameters(), args.max_grad_norm)  # 梯度剪裁，防止梯度爆炸
            optimizer.step()
            # 记录该batch的loss
            loss_meter.add(loss.item(), input_ids.size(0))
            # 计算accuracy为该batch中预测类别与真值类别相同的个数的均值
            acc = (pred.argmax(dim=-1).long() == labels).float().mean()
            acc_meter.add(acc.item(), input_ids.size(0))
        # 计算该epoch的训练loss和accuracy均值
        train_loss = loss_meter.avg()
        train_acc = acc_meter.avg()

        # validate part
        time_list[1] = time.time()
        model.eval()  # 用.eval()使模型进入测试模式
        loss_meter = AvgMeter()
        acc_meter = AvgMeter()
        for input_ids, labels, mask_ids in tqdm(val_loader):
            with torch.no_grad():  # 由于验证阶段不需要后向传播梯度，所以用torch.no_grad()防止产生梯度
                pred = model(input_ids, mask_ids)
                loss = F.cross_entropy(pred, labels)
            loss_meter.add(loss.item(), input_ids.size(0))
            acc = (pred.argmax(dim=-1).long() == labels).float().mean()
            acc_meter.add(acc.item(), input_ids.size(0))
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
    model.eval()
    loss_meter = AvgMeter()
    acc_meter = AvgMeter()

    for input_ids, labels, mask_ids in tqdm(test_loader):
        with torch.no_grad():
            pred = model(input_ids, mask_ids)
            loss = F.cross_entropy(pred, labels)
        loss_meter.add(loss.item(), input_ids.size(0))
        acc = (pred.argmax(dim=-1).long() == labels).float().mean()
        acc_meter.add(acc.item(), input_ids.size(0))
    test_loss = loss_meter.avg()
    test_acc = acc_meter.avg()

    return test_loss, test_acc


if __name__ == '__main__':
    start_time = time.time()
    parser = argparse.ArgumentParser(description='train process')
    parser.add_argument('--layer_num', default=2, type=int, help='the number of layers in transformer encoder')
    parser.add_argument('--dropout_prob', default=0.1, type=float, help='dropout probability')
    parser.add_argument('--learning_rate', default=1e-5, type=float)
    parser.add_argument("--max_grad_norm", default=1.0, type=float, help="max gradient norm")
    parser.add_argument('--batch_size', default=16, type=int)
    parser.add_argument('--epochs', default=10, type=int)
    parser.add_argument('--checkpoint_dir', default='./checkpoint', type=str, help='the directory to save checkpoint')
    args = parser.parse_args()

    train_loader, val_loader, test_loader = data_loader(batch_size=args.batch_size)  # 产生dataloader
    model, optimizer, logger, writer = preparation(args)  # 获取训练所需要的各种实例
    train_process(args, train_loader, val_loader, model, optimizer, logger, writer)  # 训练和验证
    test_loss, test_acc = test_process(args, test_loader)  # 测试
    close_logger_writer(logger, writer, start_time, test_loss, test_acc)  # 关闭log和tensorboard实例
