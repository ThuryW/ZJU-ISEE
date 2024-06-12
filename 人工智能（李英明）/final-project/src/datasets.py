from torch.nn.utils.rnn import pad_sequence
import torch
from torch.utils.data import Dataset
from torch.utils.data import DataLoader, RandomSampler, SequentialSampler
from transformers import BertTokenizer


def data_loader(batch_size):
    tokenizer = BertTokenizer.from_pretrained('./pretrained')  # load pretrained Bert model

    train_dataset = load_datasets_and_vocabs('./SST-2/train.txt', tokenizer)
    val_dataset = load_datasets_and_vocabs('./SST-2/dev.txt', tokenizer)
    test_dataset = load_datasets_and_vocabs('./SST-2/test.txt', tokenizer)

    train_sampler = RandomSampler(train_dataset)
    train_dataloader = DataLoader(train_dataset,
                                  sampler=train_sampler,
                                  batch_size=batch_size,
                                  collate_fn=collate_fn)
    val_sampler = SequentialSampler(val_dataset)
    val_dataloader = DataLoader(val_dataset,
                                sampler=val_sampler,
                                batch_size=batch_size,
                                collate_fn=collate_fn)
    test_sampler = SequentialSampler(test_dataset)
    test_dataloader = DataLoader(test_dataset,
                                 sampler=test_sampler,
                                 batch_size=batch_size,
                                 collate_fn=collate_fn)

    return train_dataloader, val_dataloader, test_dataloader


def load_datasets_and_vocabs(file, tokenizer):
    f = open(file, 'r')
    lines = f.readlines()

    all_sentence = []
    all_tag = []

    for i in range(len(lines)):
        all_tag.append(str(lines[i]).split(' ', 1)[0])
        all_sentence.append((str(lines[i]).split(' ', 1)[1]).strip('\n'))

    data = []
    for i in range(len(lines)):
        dicti = {'sentence': all_sentence[i], 'tag': all_tag[i]}
        data.append(dicti)

    dataset = Data_Dataset(data, tokenizer)

    return dataset


class Data_Dataset(Dataset):
    '''
    Convert examples to features, numericalize text to ids.
    '''
    def __init__(self, data, tokenizer):
        self.data = data
        self.tokenizer = tokenizer

        self.convert_features()

    def __len__(self):
        return len(self.data)

    def __getitem__(self, idx):
        e = self.data[idx]
        items = e['input_ids'], int(e['tag']), e['mask_id']
        items_tensor = tuple(torch.tensor(t) for t in items)
        return items_tensor

    def convert_features_bert(self, i):
        """
        BERT features.
        convert sentence to feature.
        """
        ipt = self.tokenizer.encode(
            self.data[i]['sentence'],
            add_special_tokens=True,
            max_length=100,
        )
        masked_id = [1] * len(ipt)
        self.data[i]['mask_id'] = masked_id
        self.data[i]['input_ids'] = ipt

    def convert_features(self):
        '''
        Convert sentence, aspects, pos_tags, dependency_tags to ids.
        '''
        for i in range(len(self.data)):
            self.convert_features_bert(i)
            self.data[i]['text_len'] = len(self.data[i]['input_ids'])-2


def collate_fn(batch):
    '''
    Pad sentence and aspect in a batch.
    Sort the sentences based on length.
    Turn all into tensors.
    '''
    input_ids, tag, mask_id = zip(*batch)
    tag = torch.tensor(tag)
    # Pad sequences.
    input_ids = pad_sequence(input_ids, batch_first=True, padding_value=0)
    mask_ids = pad_sequence(mask_id, batch_first=True, padding_value=0)
    return input_ids, tag, mask_ids


