import torch
import torchvision
import torchvision.transforms as transforms
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
import wandb

class Net(nn.Module):
    def __init__(self):
        super().__init__()
        self.conv1 = nn.Conv2d(3, 6, 5)
        self.pool = nn.MaxPool2d(2, 2)
        self.conv2 = nn.Conv2d(6, 16, 5)
        self.fc1 = nn.Linear(16 * 5 * 5, 120)
        self.fc2 = nn.Linear(120, 84)
        self.fc3 = nn.Linear(84, 10)

    def forward(self, x):
        x = self.pool(F.relu(self.conv1(x)))
        x = self.pool(F.relu(self.conv2(x)))
        x = torch.flatten(x, 1)
        x = F.relu(self.fc1(x))
        x = F.relu(self.fc2(x))
        x = self.fc3(x)
        return x

def get_predictions(model, inputs, optimizer):
    optimizer.zero_grad()
    return model(inputs)

def update_model(data, model, criterion, optimizer):
    inputs, labels = data
    preds = get_predictions(model, inputs, optimizer)
    loss = criterion(preds, labels)
    loss.backward()
    optimizer.step()
    return loss.item()

def get_transforms(norm=0.5):
    return transforms.Compose([transforms.ToTensor(),
                               transforms.Normalize((norm, norm, norm), (norm, norm, norm))])

def get_data(transforms, batch_size=4):
    trainset = torchvision.datasets.CIFAR10(root='./data', train=True,
                                            download=True, transform=transforms)
    trainloader = torch.utils.data.DataLoader(trainset, batch_size=batch_size,
                                            shuffle=True, num_workers=2)
    return trainloader

def save_model(model, path):
    torch.save(model.state_dict(), path)

wandb.login()

def train():
    config = {
        'norm': 0.5,
        'batch_size': 2,
        'lr': 0.001,
        'momentum': 0.9,
        'epochs': 2
    }
    
    # setup training
    with wandb.init(project='GPT-5', config=config):
        config = wandb.config

        transforms = get_transforms(config.norm)
        data = get_data(transforms, config.batch_size)
        model = Net()
        criterion = nn.CrossEntropyLoss()
        optimizer = optim.SGD(model.parameters(), lr=config.lr, momentum=config.momentum)
        
        # train model
        for epoch in range(config.epochs): 
            for i, batch in enumerate(data, 0):
                loss = update_model(batch, model, criterion, optimizer)
                
                # log results
                wandb.log({'epoch': epoch, 'loss': loss})
        path = './cifar_net.pth'
        save_model(model, path)

train()