# -*- coding: utf-8 -*-
import torchvision
import torchvision.transforms as transforms
import torch.utils.data as data
import os
import logging
import time
from tensorboardX import SummaryWriter


def data_loader(dataset_dir='./dataset', train_ratio=0.8, batch_size=128):
    """
    :param dataset_dir: the directory to restore MNIST dataset
    :param train_ratio: the ratio of training set in train_val_set
    :param batch_size: the batch size during training
    :return: dataset for training, validation and testing
    If the dataset hasn't been prepared, it will be downloaded according to download=True.
    """
    train_val_set = torchvision.datasets.MNIST(root=dataset_dir,
                                             train=True,
                                             transform=transforms.Compose([  # data preprocess
                                                 transforms.Resize((32, 32)),  # resize the input image as 32*32
                                                 transforms.ToTensor(),  # convert to tensor which can be processed by pytorch
                                                 transforms.Normalize(mean=(0.1307,), std=(0.3081,))]),  # normalize the grey image
                                             download=True)  # download the dataset in dataset_dir
    test_set = torchvision.datasets.MNIST(root=dataset_dir,
                                          train=False,
                                          transform=transforms.Compose([
                                              transforms.Resize((32, 32)),
                                              transforms.ToTensor(),
                                              transforms.Normalize(mean=(0.1307,), std=(0.3081,))]),
                                          download=True)

    # split train_set and val_set
    total_len = len(train_val_set)
    train_len = int(total_len * train_ratio)
    val_len = total_len - train_len
    train_set, val_set = data.random_split(train_val_set, lengths=[train_len, val_len])
    print(f'Size of Training set: {len(train_set)}')
    print(f'Size of Validation set: {len(val_set)}')
    print(f'Size of Testing set: {len(test_set)}')

    # generate loaders
    # use shuffle=True to introduce randomness during training
    train_loader = data.DataLoader(train_set, batch_size=batch_size, shuffle=True)
    val_loader = data.DataLoader(val_set, batch_size=batch_size, shuffle=False)
    test_loader = data.DataLoader(test_set, batch_size=batch_size, shuffle=False)

    return train_loader, val_loader, test_loader


def print_and_logger(string, logger):
    print(string)
    logger.info(string)


def init_logger(args):
    """
    初始化logger
    """
    log_dir = 'log_{}'.format(time.strftime("%Y%m%d%H%M%S", time.localtime()))
    if not os.path.exists(log_dir):
        os.makedirs(log_dir)
    logger = logging.getLogger(__name__)
    logger.setLevel(level=logging.INFO)
    f = logging.FileHandler(os.path.join(log_dir, 'log.txt'), mode='w+')
    formatter = logging.Formatter('%(asctime)s - %(message)s')
    f.setFormatter(formatter)
    logger.addHandler(f)

    l_str = '> Arguments:'
    print_and_logger(l_str, logger)
    for key in args.__dict__.keys():
        l_str = '\t{}: {}'.format(key, args.__dict__[key])
        print_and_logger(l_str, logger)

    return logger, log_dir


class DictTable(dict):
    # Overridden dict class which takes a dict in the form {'a': 2, 'b': 3},
    # and renders an HTML Table in IPython Notebook.
    def _repr_html_(self):
        html = ["<table width=100%>"]
        for key, value in self.items():
            html.append("<tr>")
            html.append("<td>{0}</td>".format(key))
            html.append("<td>{0}</td>".format(value))
            html.append("</tr>")
        html.append("</table>")
        return ''.join(html)


def init_logger_writer(args):
    """
    初始化logger（用于文字记录训练过程）和writer（用于可视化loss、acc等关注的值）
    """
    logger, log_dir = init_logger(args)
    writer = SummaryWriter(log_dir)
    writer.add_text('args', DictTable(args.__dict__)._repr_html_(), 0)  # record the training configurations

    return logger, writer


def inform_logger_writer(logger, writer, epoch, train_loss, val_loss, train_acc, val_acc, time_list):
    l_str = '[epoch {}] elapsed time: {:1.4f}s, train time: {:1.4f}s, val time: {:1.4f}s'. \
        format(epoch, time_list[2] - time_list[0], time_list[1] - time_list[0], time_list[2] - time_list[1])
    print_and_logger(l_str, logger)
    l_str = '***** Training set result ***** loss: {:1.4f}, accuracy {:1.2f}%'.format(train_loss, train_acc * 100)
    print_and_logger(l_str, logger)
    l_str = '***** Validation set result ***** loss: {:1.4f}, accuracy {:1.2f}%'.format(val_loss, val_acc * 100)
    print_and_logger(l_str, logger)

    writer.add_scalar('train/loss', train_loss, epoch)
    writer.add_scalar('train/accuracy', train_acc * 100, epoch)
    writer.add_scalar('val/loss', val_loss, epoch)
    writer.add_scalar('val/accuracy', val_acc * 100, epoch)


def close_logger_writer(logger, writer, start_time, test_loss, test_acc):
    print_and_logger(' ', logger)
    l_str = 'Elapsed time {}'.format(time.strftime('%H:%M:%S', time.gmtime(time.time() - start_time)))
    print_and_logger(l_str, logger)
    l_str = '***** Test set result ***** loss: {:1.4f}, accuracy {:1.2f}%'.format(test_loss, test_acc * 100)
    print_and_logger(l_str, logger)

    loggers = list(logger.handlers)
    for i in loggers:
        logger.removeHandler(i)
        i.flush()
        i.close()
    writer.close()


class AvgMeter(object):
    def __init__(self):
        self.cnt = 0
        self.sum = 0

    def add(self, x, cnt=1):
        self.sum += x * cnt
        self.cnt += cnt

    def avg(self):
        assert self.cnt != 0
        return self.sum / self.cnt
