import math
import torch
import torch.nn as nn


class pure_transformer(nn.Module):
    """
    build a pure transformer including dropout
    """
    def __init__(self, layer_num=2, hidden_size=256, class_num=2, dropout_prob=0.1):
        super(pure_transformer, self).__init__()
        # embedding层将词典中的每个词（用下标表示）对应到维度为hidden_size的embedding表示
        self.embedding = nn.Embedding(num_embeddings=30522, embedding_dim=hidden_size)
        # 由于是分类任务，只需要用到transformer的encoder部分
        self.transformer_encoder = TransformerEncoder(d_model=hidden_size,
                                                      d_ff=1024,
                                                      head_num=8,
                                                      dropout_prob=dropout_prob,
                                                      layer_num=layer_num)
        # 用两层全连接层构建分类器
        # TODO1，请填写分类器最后一层全连接层的输入输出维度
        self.classifier = nn.Sequential(nn.Linear(in_features=hidden_size, out_features=hidden_size),
                                        nn.ReLU(),
                                        nn.Linear(in_features='x_x', out_features='x_x'))

    def forward(self, input_ids, mask_ids):
        input_emb = self.embedding(input_ids)
        out = self.transformer_encoder(input_emb, mask_ids)
        pooled_out = out[:, 0, :]
        logits = self.classifier(pooled_out)

        return logits


class TransformerEncoder(nn.Module):
    def __init__(self, d_model, d_ff, head_num, dropout_prob, layer_num=2):
        super(TransformerEncoder, self).__init__()
        self.d_model = d_model
        self.layer_num = layer_num
        # 定义dropout
        if dropout_prob > 0:
            dropout_layer = nn.Dropout(dropout_prob)
        else:
            dropout_layer = None
        # 因为每个layer的配置是相同的，可以用for循环简洁地构建。通过nn.ModuleList注册参数，否则无法训练。
        self.transformer_enc_layers = nn.ModuleList([TransformerEncoderLayer(d_model, head_num, d_ff, dropout_layer)
                                                    for _ in range(layer_num)])

    def forward(self, top_vecs, mask):
        # 这一步mask=1处代表需要保留的数据
        x = top_vecs * mask[:, :, None].float()
        for i in range(self.layer_num):
            x = self.transformer_enc_layers[i](x, 1 - mask)  # 传入transformer_enc_layers里的mask=1处代表需要忽略的数据

        return x


class TransformerEncoderLayer(nn.Module):
    def __init__(self, d_model, head_num, d_ff, dropout_layer):
        super(TransformerEncoderLayer, self).__init__()
        self.self_attn = MultiHeadedAttention1(head_num, d_model, dropout_layer)
        self.feed_forward = PositionwiseFeedForward(d_model, d_ff, dropout_layer)
        # TODO2，请填写layer_norm函数，可直接使用torch.nn里的函数
        self.layer_norm = 'x_x'
        self.dropout_layer = dropout_layer

    def forward(self, x, mask):
        mask = mask.unsqueeze(1)
        # TODO3，多头自注意力模块计算
        context = self.self_attn(query='x_x', key='x_x', value='x_x', mask=mask)
        if self.dropout_layer is not None:
            context = self.dropout_layer(context)
        # TODO4，参考transformer论文的LayerNorm(x + Sublayer(x))
        x = 'x_x'
        # 前馈网络模块计算
        ff_out = self.feed_forward(x)
        if self.dropout_layer is not None:
            ff_out = self.dropout_layer(ff_out)
        # TODO4，参考transformer论文的LayerNorm(x + Sublayer(x))
        x = 'x_x'

        return x


class PositionwiseFeedForward(nn.Module):
    """
    前馈网络，主要由两层全连接层组成，第一层映射到高维，并经过激活函数，第二层映射回输入维度
    """
    def __init__(self, d_model, d_ff, dropout_layer):
        super(PositionwiseFeedForward, self).__init__()
        # TODO5，请填写两个全连接层的输入输出维度，__init__的参数d_model代表贯穿模型使用的维度，d_ff代表第一个全连接层要映射到的高维
        self.fc_layer1 = nn.Linear(in_features='x_x', out_features='x_x')
        self.fc_layer2 = nn.Linear(in_features='x_x', out_features='x_x')

        # TODO6，请填写激活函数，根据transformer论文max(0; xW1 + b1)可知是ReLU，可直接使用torch.nn里的函数
        self.activation = 'x_x'
        self.dropout_layer = dropout_layer

    def forward(self, x):
        x = self.fc_layer1(x)
        x = self.activation(x)
        if self.dropout_layer is not None:
            x = self.dropout_layer(x)
        x = self.fc_layer2(x)

        return x


def scaled_dot_product(query, key, value, softmax, dropout_layer, mask=None):
    """
    自注意力机制
    """
    # TODO7，请获得query和key的维度d_k
    d_k = 'x_x'
    # TODO8，初始score=query乘key的转置
    scores = torch.matmul('x_x', 'x_x')
    # TODO9，使用根号d_k对scores进行scale，防止矩阵相乘后得到的数值过大，影响梯度回传
    scores = 'x_x'
    # 屏蔽掉不需要考虑的数据
    # 为了让一个batch输入的数据长度一致，对较短的序列进行了补零
    # 但补零的位置是实际计算自注意力不希望被考虑进来的
    if mask is not None:
        mask = mask.expand_as(scores)
        mask_new = mask * -10000.0
        scores = scores + mask_new  # 让需要屏蔽位置的score变成很小的负数，这样在计算softmax时经过exp就会接近于0
    scores = softmax(scores)

    if dropout_layer is not None:
        scores = dropout_layer(scores)
    # TODO10，输出为scores乘value
    result = torch.matmul('x_x', 'x_x')

    return result


class MultiHeadedAttention1(nn.Module):
    """
    多头自注意力模块
    """
    def __init__(self, head_num, d_model, dropout_layer):
        super(MultiHeadedAttention1, self).__init__()
        assert d_model % head_num == 0
        self.d_k = d_model // head_num  # 每个头对应的query、key、value的维度
        self.d_model = d_model
        self.head_num = head_num

        self.linear_project_query = nn.ModuleList([nn.Linear(in_features=self.d_model, out_features=self.d_k) for _ in range(self.head_num)])
        self.linear_project_key = nn.ModuleList([nn.Linear(in_features=self.d_model, out_features=self.d_k) for _ in range(self.head_num)])
        self.linear_project_value = nn.ModuleList([nn.Linear(in_features=self.d_model, out_features=self.d_k) for _ in range(self.head_num)])
        self.final_linear_project = nn.Linear(in_features=d_model, out_features=d_model)
        self.softmax = nn.Softmax(dim=-1)
        self.dropout_layer = dropout_layer

    def forward(self, query, key, value, mask=None):
        context = []
        for i in range(self.head_num):
            # TODO11，请用各个linear_project层计算投影到低维空间的q、k、v
            q = 'x_x'
            k = 'x_x'
            v = 'x_x'
            context.append(scaled_dot_product(q, k, v, self.softmax, self.dropout_layer, mask))
        context = torch.concat(context, dim=-1)
        output = self.final_linear_project(context)

        return output


class MultiHeadedAttention2(nn.Module):
    """
    用pytorch并行矩阵运算的多头自注意力模块
    """
    def __init__(self, head_num, d_model, dropout_layer):
        super(MultiHeadedAttention2, self).__init__()
        assert d_model % head_num == 0
        self.d_per_head = d_model // head_num
        self.d_model = d_model
        self.head_num = head_num

        self.linear_project_query = nn.Linear(in_features=d_model, out_features=d_model)
        self.linear_project_key = nn.Linear(in_features=d_model, out_features=d_model)
        self.linear_project_value = nn.Linear(in_features=d_model, out_features=d_model)
        self.final_linear_project = nn.Linear(in_features=d_model, out_features=d_model)
        self.softmax = nn.Softmax(dim=-1)
        self.dropout_layer = dropout_layer

    def forward(self, query, key, value, mask=None):
        query = self.linear_project_query(query)
        key = self.linear_project_key(key)
        value = self.linear_project_value(value)
        """
        TODO12，请填写合理的代码段，对query、key、value进行转置与reshape，使其与分别计算多头注意力的结果相同
        """
        if mask is not None:
            mask = mask.unsqueeze(1)
        context = scaled_dot_product(query, key, value, self.softmax, self.dropout_layer, mask)
        """
        TODO13，请填写合理的代码段，对context进行转置与reshape，使其恢复到x的shape
        """
        output = self.final_linear_project(context)

        return output