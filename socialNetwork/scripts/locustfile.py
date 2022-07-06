from locust import FastHttpUser, task
import random
import logging
import time

import locust.stats
locust.stats.CSV_STATS_INTERVAL_SEC = 1

random.seed(time.time())
logging.basicConfig(level=logging.INFO)

charset = ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', 'a', 's',
  'd', 'f', 'g', 'h', 'j', 'k', 'l', 'z', 'x', 'c', 'v', 'b', 'n', 'm', 'Q',
  'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', 'A', 'S', 'D', 'F', 'G', 'H',
  'J', 'K', 'L', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '1', '2', '3', '4', '5',
  '6', '7', '8', '9', '0']

max_user_index = 962

def random_string(length):
    global charset
    if length > 0:
        s = ""
        for i in range(0, length):
            s += random.choice(charset)
        return s
    else:
        return ""

mean_iat = 10  # seconds

class SocialMediaUser(FastHttpUser):
    # return wait time in second
    def wait_time(self):
        global mean_iat
        return random.expovariate(lambd=1/mean_iat)
    
    def on_start(self):
        time.sleep(random.expovariate(lambd=1/mean_iat))

    @task(1)
    def compose_post(self):
        user_id = str(random.randint(0, max_user_index - 1))
        text = random_string(256)
        num_user_mentions = random.randint(0, 5)
        num_urls = random.randint(0, 5)

        #---- user mentions ----#
        for i in range(0, num_user_mentions):
            while True:
                user_mention_id = str(random.randint(0, max_user_index - 1))
                if user_id != user_mention_id:
                    break
            text = text + " @username_" + user_mention_id

        #---- urls ----#
        for i in range(0, num_urls):
            text = text + " http://" + random_string(64)

        url = '/wrk2-api/post/compose'
        body = {}
        body['text'] = text

        self.client.post(url, params={}, data=body, name='compose_post')
