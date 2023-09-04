const functions = require('firebase-functions');
const admin = require('firebase-admin');
// const functionsHttp = require('@google-cloud/functions-framework');
// const escapeHtml = require('escape-html');

admin.initializeApp();

exports.onFollowUser = functions.firestore
  .document('/followers/{userId}/userFollowers/{followerId}')
  .onCreate(async (_, context) => {
    const userId = context.params.userId;
    const followerId = context.params.followerId;
     // Get the owners details
    
    // Increment followed user's followers count.
    const followedUserRef = admin.firestore().collection('users').doc(userId);
    const followedUserDoc = await followedUserRef.get();
    if (followedUserDoc.get('followers') !== undefined) {
      followedUserRef.update({
        followers: followedUserDoc.get('followers') + 1,
      });
    } else {
      followedUserRef.update({ followers: 1 });
    }

    // Increment user's following count.
    const userRef = admin.firestore().collection('users').doc(followerId);
    const userDoc = await userRef.get();
   // console.log(userDoc);
    if (userDoc.get('following') !== undefined) {
      userRef.update({ following: userDoc.get('following') + 1 });
    } else {
      userRef.update({ following: 1 });
    }

   const  followerName = userDoc.get('name');
   const  followerProfilePic = userDoc.get('profilePic');

   const payload = {'icon': followerProfilePic, 'followerId': followerId};
      
    await admin.messaging().sendToDevice(
     // owner.tokens, // ['token_1', 'token_2', ...]
     followedUserDoc.get('tokens'),
      {
        notification: {
          title: 'You have a new follower',
          body: followerName + ' is now following you.',
          
          //imageUrl: 'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425__340.png'
         // body: 'Rishu is now following you',
         // icon: 'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425__340.png'
        },
       // data: {'icon': followerProfilePic}
       data: payload
       //{'icon': 'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425__340.png'}
       // data: JSON.stringify(payload)
       // body: 'You have a new follower!',
       // icon: follower.photoURL
        // data: {
        //   follower: JSON.stringify(userDoc),
        //   followedUser: JSON.stringify(followedUserDoc),
        //  // picture: JSON.stringify(picture),
        // },
      },
      {
        // Required for background/quit data-only messages on iOS
        contentAvailable: true,
        // Required for background/quit data-only messages on Android
        priority: "high",
      }
    );

    // Add followed user's posts to user's post feed.
    // const followedUserPostsRef = admin
    //   .firestore()
    //   .collection('posts')
    //   .where('author', '==', followedUserRef);
    // const userFeedRef = admin
    //   .firestore()
    //   .collection('feeds')
    //   .doc(followerId)
    //   .collection('userFeed');
    // const followedUserPostsSnapshot = await followedUserPostsRef.get();
    // followedUserPostsSnapshot.forEach((doc) => {
    //   if (doc.exists) {
    //     userFeedRef.doc(doc.id).set(doc.data());
    //   }
    // });
  });

exports.onUnfollowUser = functions.firestore
  .document('/followers/{userId}/userFollowers/{followerId}')
  .onDelete(async (_, context) => {
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    // Decrement unfollowed user's followers count.
    const followedUserRef = admin.firestore().collection('users').doc(userId);
    const followedUserDoc = await followedUserRef.get();
    if (followedUserDoc.get('followers') !== undefined) {
      followedUserRef.update({
        followers: followedUserDoc.get('followers') - 1,
      });
    } else {
      followedUserRef.update({ followers: 0 });
    }

    // Decrement user's following count.
    const userRef = admin.firestore().collection('users').doc(followerId);
    const userDoc = await userRef.get();
    if (userDoc.get('following') !== undefined) {
      userRef.update({ following: userDoc.get('following') - 1 });
    } else {
      userRef.update({ following: 0 });
    }

    // Remove unfollowed user's posts from user's post feed.
    const userFeedRef = admin
      .firestore()
      .collection('feeds')
      .doc(followerId)
      .collection('userFeed')
      .where('author', '==', followedUserRef);
    const userPostsSnapshot = await userFeedRef.get();
    userPostsSnapshot.forEach((doc) => {
      if (doc.exists) {
        doc.ref.delete();
      }
    });
  });

exports.onCreatePost = functions.firestore
  .document('/posts/{postId}')
  .onCreate(async (snapshot, context) => {
    const postId = context.params.postId;

    // Get author id.
    const authorRef = snapshot.get('author');
    const authorId = authorRef.path.split('/')[1];

    // Add new post to feeds of all followers.
    const userFollowersRef = admin
      .firestore()
      .collection('followers')
      .doc(authorId)
      .collection('userFollowers');
    const userFollowersSnapshot = await userFollowersRef.get();
    userFollowersSnapshot.forEach((doc) => {
      admin
        .firestore()
        .collection('feeds')
        .doc(doc.id)
        .collection('userFeed')
        .doc(postId)
        .set(snapshot.data());
    });
  });

exports.onUpdatePost = functions.firestore
  .document('/posts/{postId}')
  .onUpdate(async (snapshot, context) => {
    const postId = context.params.postId;

    // Get author id.
    const authorRef = snapshot.after.get('author');
    const authorId = authorRef.path.split('/')[1];

    // Update post data in each follower's feed.
    const updatedPostData = snapshot.after.data();
    const userFollowersRef = admin
      .firestore()
      .collection('followers')
      .doc(authorId)
      .collection('userFollowers');
    const userFollowersSnapshot = await userFollowersRef.get();
    userFollowersSnapshot.forEach(async (doc) => {
      const postRef = admin
        .firestore()
        .collection('feeds')
        .doc(doc.id)
        .collection('userFeed');
      const postDoc = await postRef.doc(postId).get();
      if (postDoc.exists) {
        postDoc.ref.update(updatedPostData);
      }
    });
  });
  

  // notification on adding comment

  exports.onComment = functions.https.onCall(async (data, context) => {

    const authorId = data.authorId;

    const storyAuthorId = data.storyAuthorId;

    const storyId = data.storyId;
  
    const authorDoc = await admin.firestore().collection('users').doc(authorId).get();

    const postAuthorDoc = await admin.firestore().collection('users').doc(storyAuthorId).get();

   // const storyDoc = await admin.firestore().collection('stories').doc(storyId).get();

    const  authorName = authorDoc.get('name');
    const  authorProfileImg = authorDoc.get('profilePic');
   // const  storyObj = Object.fromEntries(storyDoc.data());
 
    // const payload = {'icon': authorProfileImg, 'route': 'comment', 'story':JSON.stringify(storyDoc)};
    // const payload = {'icon': authorProfileImg, 'route': 'comment', 'story':JSON.stringify(storyDoc.data())};
    // const payload = {'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'icon': authorProfileImg, 'route': 'comment', storyId: storyId, storyAuthorId: storyAuthorId};
    const payload = {'icon': authorProfileImg, 'route': 'comment', storyId: storyId, storyAuthorId: storyAuthorId};
       
     await admin.messaging().sendToDevice(
      postAuthorDoc.get('tokens'),
       {
         notification: {
           title: 'You have a new comment',
           body: authorName + ' commented on your post',
         },

        data: payload
       
       },
       {
         // Required for background/quit data-only messages on iOS
         contentAvailable: true,
         // Required for background/quit data-only messages on Android
         priority: 'high',
       }
     );

  });


  // HTTP Cloud Function.
// functionsHttp.http('helloHttp', (req, res) => {
//   res.send(`Hello ${escapeHtml(req.query.name || req.body.name || 'World')}!`);
// });


exports.date = functions.https.onRequest((req, res) => {
// this funtion url - https://us-central1-<project-id>.cloudfunctions.net/date
//https://us-central1-viewyourstories-4bf4d.cloudfunctions.net/date
const data = req.query;

 // Important: Make sure that all HTTP functions terminate properly.
 // By terminating functions correctly, you can avoid excessive charges from functions that run for too long. Terminate HTTP functions with res.redirect(), res.send(), or res.end().
 // resourse - https://firebase.google.com/docs/functions/http-events
 //res.redirect('https://flutter.dev/');
 res.send(data);
});


exports.scheduledFunctionCrontab = functions.pubsub.schedule('5 11 * * *').onCall(async (data, context) => {

  const authorId = data.authorId;
  const audioId = data.audioId;
  await admin.collection('dashboard').doc(authorId).collection('audioReceived').doc(audioId).delete();


});
