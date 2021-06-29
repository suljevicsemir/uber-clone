package com.semirsuljevic.uber_clone

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.media.AudioAttributes
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import java.text.SimpleDateFormat
import java.util.*

class UberMessagingService:FirebaseMessagingService() {




    override fun onCreate() {
        super.onCreate()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "RideArrival"
            val descriptionText = "Channel for Ride Arriving"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel("RideArrival", name, importance).apply {
                description = descriptionText
            }
            val notificationManager: NotificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    override fun onNewToken(p0: String) {
        super.onNewToken(p0)

    }



    private fun vibrate() {

        val vibrator = applicationContext.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            vibrator.vibrate(VibrationEffect.createOneShot(2000, 255), AudioAttributes.Builder()
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .build())
        } else {
            @Suppress("DEPRECATION")
            vibrator.vibrate(2000);

        }
    }

    override fun onMessageReceived(message: RemoteMessage) {
        super.onMessageReceived(message)

        val now = Date();
        val notificationId: Int = SimpleDateFormat("ddHHmmss", Locale.US).format(now).toInt();

        val contentTitle: String
        val contentText: String

        /*// ride arrival
        if ( message.data.containsKey("location")) {
            contentTitle = "Your ride is here";
            contentText = message.data["firstName"] + " " + message.data["lastName"] + " is here to pick you up!"
        }
        // driver answered request
        else {
            contentTitle = "Driver answered your request."
            contentText = message.data["firstName"] + " " + message.data["lastName"] + " will pick you up in: " + message.data["expectedArrival"]
        }*/
        
        val noticedDriverAction = Intent(this, DriverNoticedReceiver::class.java)
        val trackDriverAction = Intent(this, TrackDriverReceiver::class.java)

        noticedDriverAction.putExtra("notificationId", notificationId);
        trackDriverAction.putExtra("notificationId", notificationId);
            
        trackDriverAction.putExtra("rideId", "unique ajdentifikator")
        trackDriverAction.putExtra("driverId", "unique drajver")

        val driverNoticed:PendingIntent = PendingIntent.getBroadcast(this, 1, noticedDriverAction, PendingIntent.FLAG_UPDATE_CURRENT)
        val trackDriver: PendingIntent = PendingIntent.getBroadcast(this, 2, trackDriverAction, PendingIntent.FLAG_UPDATE_CURRENT)

        val builder = NotificationCompat.Builder(this, "RideArrival")
                .setSmallIcon(R.drawable.app_icon)
                .setColor(Color.BLACK)
                .setContentTitle(message.data["title"])
                .setContentText(message.data["message"])
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setAutoCancel(true)
                .setContentIntent(PendingIntent.getActivity(this, 0, Intent(), 0))


        builder
            .addAction(R.drawable.app_icon, "I see the driver", driverNoticed)
            .addAction(R.drawable.app_icon, "Track driver location", trackDriver)

        vibrate()

        with(NotificationManagerCompat.from(this)) {
            notify(notificationId, builder.build())

        }
    }
}