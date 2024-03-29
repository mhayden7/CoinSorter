# Lab 2 - Archiving and Event Replay

In the previous lab we created a bunch of coin objects, but we didn't have a rule or queue for handling dollars. Let's add that now.  
```sh
./publish.sh 2
```  
But what about those dollars we missed out on in lab 1? Thank goodness we also created an event archive! We are going to replay events from the archive to recover those dollars. It can take a few minutes for events to make it to the archive, so take a 5-10 minute break. Go fill a cup/mug with your beverage of choice, I prefer a constant stream of coffee, then wend your way back here.  

To ensure the archive is ready you should see "Size in bytes" appear as anything greater than 0.  
![archive size](lab_2_event_bus_archive_size.png)  

Now let's do a replay! Select the archive and then the Replay button. Enter your settings similar to below (adjusting for date). Notice that you can select replaying events to ALL rules or just a subset of rules, in this case we only want to catch those dollars we missed so select the dollar event rule:  
![replay settings](lab_2_replay_settings.png)  
Now click "Start Replay". It may take a few moments to begin, but should complete quickly. If you check SQS now you should see that the dollar queue has your missing money.  
![dollars found! Scrooge McDuck is happy!](lab_2_sqs_result.png)  

# Lab 2 Complete!
When you're done playing with tester.py and replays, make sure to clean up.
```sh
./destroy.sh
```