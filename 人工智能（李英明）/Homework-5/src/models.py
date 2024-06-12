# -*- coding: utf-8 -*-
from turtle import forward
import torch
import torch.nn as nn


class LeNet5(nn.Module):
    def __init__(self) -> None:
        super().__init__()
        """
        TODO:
        请根据作业要求，用合适的数字替换下面代码中的'^_^'
        """
        self.conv = nn.Sequential(
            nn.Conv2d(in_channels=1, out_channels=6, kernel_size=5, stride=1),
            nn.Tanh(),
            nn.AvgPool2d(kernel_size=2, stride=2),
            nn.Conv2d(in_channels=6, out_channels=16, kernel_size=5, stride=1),
            nn.Tanh(),
            nn.AvgPool2d(kernel_size=2, stride=2),
            nn.Conv2d(in_channels=16, out_channels=120, kernel_size=5, stride=1),
            nn.Tanh()
        )
        self.fc = nn.Sequential(
            nn.Linear(in_features=120, out_features=84),
            nn.Tanh(),
            nn.Linear(in_features=84, out_features=10)
        )

    def forward(self, input):
        """
        input: [B, 1, 32, 32]
        """
        batch_size = input.size(0)
        x = self.conv(input).reshape(batch_size, -1)
        x = self.fc(x)
        return x


class LeNet4(nn.Module):
    def __init__(self) -> None:
        super().__init__()
        self.conv = nn.Sequential(
            nn.Conv2d(in_channels=1, out_channels=6, kernel_size=5, stride=1),
            nn.Tanh(),
            nn.AvgPool2d(kernel_size=4, stride=4),
            nn.Conv2d(in_channels=6, out_channels=120, kernel_size=7, stride=1),
            nn.Tanh()
        )
        self.fc = nn.Sequential(
            nn.Linear(in_features=120, out_features=84),
            nn.Tanh(),
            nn.Linear(in_features=84, out_features=10)
        )

    def forward(self, input):
        """
        input: [B, 1, 32, 32]
        """
        batch_size = input.size(0)
        x = self.conv(input).reshape(batch_size, -1)
        x = self.fc(x)
        return x


class MSELoss(nn.Module):
    def __init__(self):
        super().__init__()
        self.l2 = nn.MSELoss()

    def forward(self, estimate, target):
        n = estimate.size(1)
        # 将target转换为one-hot编码形式
        target = target.unsqueeze(1).long() == torch.arange(n).unsqueeze(0)
        return self.l2(estimate, target.float())
