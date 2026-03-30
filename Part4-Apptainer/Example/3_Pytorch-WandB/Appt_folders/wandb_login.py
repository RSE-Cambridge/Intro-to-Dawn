import wandb

run = wandb.init(
    # Set the wandb entity where your project will be logged (generally your team name).
    entity="sh824-university-of-cambridge",
    # Set the wandb project where this run will be logged.
    project="start1-project",
)
run.log({'example_metric': 1})
run.finish()
