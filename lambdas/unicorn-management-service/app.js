const randomBytes = require('crypto').randomBytes;

const AWS = require('aws-sdk');

const ddb = new AWS.DynamoDB.DocumentClient();
const sns = new AWS.SNS({
    apiVersion: '2010-03-31'
});

const fleet = [{
    Name: 'Bucephalus',
    Color: 'Golden',
    Gender: 'Male',
},
    {
        Name: 'Shadowfax',
        Color: 'White',
        Gender: 'Male',
    },
    {
        Name: 'Rocinante',
        Color: 'Yellow',
        Gender: 'Female',
    },
];

const username = process.env.username;

exports.handler = (event, context, callback) => {
    // Log to Cloudwatch the content of the event object received by this lambda
    // function
    console.log(event);

    const rideId = toUrlString(randomBytes(16));
    console.log('Received event (', rideId, '): ', event);

    // The body field of the event in a proxy integration is a raw string.
    // In order to extract meaningful values, we need to first parse this string
    // into an object. A more robust implementation might inspect the Content-Type
    // header first and use a different parsing strategy based on that value.
    const requestBody = JSON.parse(event.body);

    // Unpack the request body and extract the variables we need later
    const pickupLocation = requestBody.PickupLocation;
    const fare = requestBody.fare;
    const distance = requestBody.distance;
    const unicorn = findUnicorn(pickupLocation);

    // Record the ride in the dynamoDB table
    recordRide(rideId, username, unicorn).then(() => {

        // If the record was added succesfully, then send a notification to the SNS
        // topic
        sendNotification(rideId, username, unicorn, fare, distance).then(
            function(data) {
                console.log(`A Message has been sent to the topic`);
                console.log("MessageID is " + data.MessageId);
            }).catch(
            function(err) {
                console.error(err, err.stack);
            });

        // You can use the callback function to provide a return value from your Node.js
        // Lambda functions. The first parameter is used for failed invocations. The
        // second parameter specifies the result data of the invocation.

        // Because this Lambda function is called by an API Gateway proxy integration
        // the result object must use the following structure.
        callback(null, {
            statusCode: 201,
            body: JSON.stringify({
                RideId: rideId,
                Unicorn: unicorn,
                UnicornName: unicorn.Name,
                Eta: '30 seconds',
                Rider: username,
            }),
            headers: {
                'Access-Control-Allow-Origin': '*',
            },
        });
    }).catch((err) => {
        console.error(err);

        // If there is an error during processing, catch it and return
        // from the Lambda function successfully. Specify a 500 HTTP status
        // code and provide an error message in the body. This will provide a
        // more meaningful error response to the end client.
        errorResponse(err.message, context.awsRequestId, callback)
    });
};

// This is where you would implement logic to find the optimal unicorn for
// this ride (possibly invoking another Lambda function as a microservice.)
// For simplicity, we'll just pick a unicorn at random.
function findUnicorn(pickupLocation) {
    console.log('Finding unicorn for ', pickupLocation.Latitude, ', ', pickupLocation.Longitude);
    return fleet[Math.floor(Math.random() * fleet.length)];
}

// ----------------------------------------------------------------------------
// Record in DynamoDB table
// ----------------------------------------------------------------------------
function recordRide(rideId, username, unicorn) {
    return ddb.put({
        TableName: process.env.ddb_table,
        Item: {
            RideId: rideId,
            User: username,
            Unicorn: unicorn,
            UnicornName: unicorn.Name,
            RequestTime: new Date().toISOString(),
        },
    }).promise();
}


function toUrlString(buffer) {
    return buffer.toString('base64')
        .replace(/\+/g, '-')
        .replace(/\//g, '_')
        .replace(/=/g, '');
}

// ----------------------------------------------------------------------------
// Send notification to SNS topic passing additional attributes in the message
// ----------------------------------------------------------------------------
function sendNotification(rideId, username, unicorn, fare, distance) {
    var message = {
        Message: 'A ride (' + rideId + ') has been requested for user ' + username + ' with unicorn ' + unicorn.Name,
        /* required */
        MessageAttributes: {
            fare: {
                DataType: 'Number',
                StringValue: JSON.stringify(fare)
            },
            distance: {
                DataType: 'Number',
                StringValue: JSON.stringify(distance)
            },
        },
        TopicArn: process.env.sns_topic_arn
    };

    return sns.publish(message).promise();
}

// ----------------------------------------------------------------------------
// Handling errors
// ----------------------------------------------------------------------------
function errorResponse(errorMessage, awsRequestId, callback) {
    callback(null, {
        statusCode: 500,
        body: JSON.stringify({
            Error: errorMessage,
            Reference: awsRequestId,
        }),
        headers: {
            'Access-Control-Allow-Origin': '*',
        },
    });
}