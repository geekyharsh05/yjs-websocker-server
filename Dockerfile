FROM node:20-alpine

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
WORKDIR /home/node/app

# Copy package files with correct ownership
COPY --chown=node:node package*.json ./

# Switch to node user before npm install
USER node

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY --chown=node:node . .

EXPOSE 1234
CMD [ "npm", "start" ]