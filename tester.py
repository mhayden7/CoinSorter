import random
import boto3
import json
import argparse
import time
import botocore
import yaml

argparser = argparse.ArgumentParser(prog='coin sorter')
argparser.add_argument('-p', '--purge', action='store_true')
argparser.add_argument('-cc', '--coin_count')
args = argparser.parse_args()

coin_types = ['dollar', 'quarter', 'dime', 'nickel', 'penny']


def purge(sqs, queue_url):
    try:
        sqs.purge_queue(QueueUrl=queue_url)
    except sqs.exceptions.QueueDoesNotExist as e:
        print(f"Queue {queue_url} does not exist.")


def purge_queues():
    with open("env-config.yaml") as config_file:
        config = yaml.safe_load(config_file)

    for region in [config['primary_region'], config['secondary_region']]:
        sqs = boto3.client('sqs', region_name=region)
        for coin in coin_types:
            url = f"https://sqs.{region}.amazonaws.com/{config['account']}/{coin}"
            print(f"Purging {url}...")
            purge(sqs, url)


def create_coins(count):
    coins = []
    for i in range(count):
        coins.append({
            'type': random.choice(coin_types),
            'year': random.randrange(1900, 2025)
            })
    return coins


def deposit_change(coins):
    client = boto3.client('events')
    for coin in coins:
        print(coin)
        response = client.put_events( 
            Entries=[
                {
                    'Source': 'pocket-change',
                    'DetailType': coin['type'],
                    'Detail': json.dumps(coin),
                    'EventBusName': 'coin_sorter'
                }
            ]
        )
        # print(response) # Having issues? Try printing the response to get error codes.



if __name__ == "__main__":
    if args.purge:
        purge_queues()

    if args.coin_count:
        coins = create_coins(int(args.coin_count))
        deposit_change(coins)
