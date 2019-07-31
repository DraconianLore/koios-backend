# Κοῖος (back-end)

---------------------------------------

## A full stack project built for our team final project at Lighthouse Labs. 
### Tech Stack:
- **Frontend**: React-Native [--> github repo](https://github.com/DraconianLore/Koios)
- **Backend**: Ruby on Rails 
- **Database**: PostgreSQL

--------------------------------------

## Team members:
- [Steven Wing](https://draconianlore.github.io)
- [Seth Marks](https://S-Marks.github.io)
# Κοῖος

---------------------------------------

## What is Κοῖος?

Κοῖος is an immersive game where users enlist as agents in a secret organization where they are encouraged to take a break from their daily lives and complete missions by interacting with the world around them.
Initially users are presented with baisc 'training' missions to build up trust within the organisation, taking photos of objects, taking selfies with other people or places, and sending them off to be verified by other agents(including new agents)
As they gain trust, they gain ranks in the organisation which leads to harder missions including:

* **Encryption missions** - where the agent is given a word or phrase and must encrypt it using a type of cypher provided.
* **Decryption missions** - where the agent is given an encrypted message and must discover the type of encryption used and decypher the message.
* *To be implemented in later updates*
 * **Dead-drop missions** - where the agent must write out or print a message and leave it in a location where another agent will come to pick it up.
 * **Handoff missions** - where the agent must meet another agent and secretly hand them a message.
 * **Advanced decryption missions** - where the agent recieves an image, sound clip, or video clip and must find a message hidden in the file.

*Once we have enough users in an area, we plan on running a social experiment similar to the MP3 Experiments*

----------------------------------------

## Setup:
Eventually we plan on adding our app to the Apple App Store and Google Play, but for now the back-end is hosted on Heroku, and the front-end needs to be run on a local machine using Expo.

Clone this repository if you want to use that seperate from the Heroku hosted one, and also the front(link above).
### Front-end:

- run `npm install` to get all required dependancies
- run `npm start` to start the app
- Download the 'Expo' app on your device
- scan the QR Code that appears in your terminal(or browser if you prefer)

### Back-end:

- run `bundle install` to get all the required dependancies
- create a `.env` file in your root directory and add your AWS S3 keys in
 - AWS_ACCESS_KEY_ID=/your key here/
 - AWS_SECRET_ACCESS_KEY=/your key here/
 - AWS_REGION=/your AWS region here/
- run `rails s` to start the server on default ports
 - alternative run `rails s -p /your port here/ -b 0.0.0.0` to run on your preferred port at localhost


