## Url Unfurl

When a user posts a GitHub url on the channel, we show an unfurled card to the user with the important information of the resource.

## Flow:

1. When a user posts github url in Teams channel, we get a request and we handle it in the function - handleTeamsAppBasedLinkQuery.
2. We fetch the github client and the user information.
3. We check if the url provided is public or private.
4. In case the url is public, we unfurl the url for the user. In case the url is private, we unfurl it if the user is signed in, otherwise we prompt the user to signin.
5. We get the attachment for the response using the function - getUnfurlAttachment.
6. In this function, We first get the url type using regex matching and fetch the required parameters corresponding to that url type.
7. Then we pass the parameters to the constructCardJson to create the card using the template for the url type.
8. We then return the final attachment for the url to the main function.
9. The main function then contructs a compose extension response with the attachment and the unfurl card is posted to the Teams channel.

## Flow Chart:

![Teams Url unfurl](./../../images/teams-unfurl-flowchart.png "Flow Chart for Teams Url unfurl")
