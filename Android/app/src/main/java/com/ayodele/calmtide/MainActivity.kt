package com.ayodele.calmtide

import android.Manifest
import android.annotation.SuppressLint
import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import androidx.activity.ComponentActivity
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Slider
import androidx.compose.material3.Surface
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import kotlinx.coroutines.delay
import kotlin.math.PI
import kotlin.math.roundToInt
import kotlin.math.sin

private const val CHANNEL_ID = "calmtide_reminders"
private const val PREFS = "calmtide_settings"
private const val ACTION_REMINDER = "com.ayodele.calmtide.REMINDER"
private const val REQUEST_CODE_REMINDER = 4107

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createReminderChannel(this)

        setContent {
            CalmTideTheme {
                CalmTideApp()
            }
        }
    }
}

class ReminderReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != ACTION_REMINDER) return

        val settings = BreathingSettings.load(context)
        if (!settings.remindersEnabled) return

        sendReminderNotification(context)
        scheduleReminder(context, settings.reminderIntervalMinutes)
    }
}

private enum class Phase(val label: String, val cue: String) {
    Inhale("Inhale", "Let the tide rise"),
    Hold("Hold", "Stay with the still water"),
    Exhale("Exhale", "Let the tide soften"),
    Rest("Rest", "Rest on the shore")
}

private data class BreathingSettings(
    val cycles: Int = 4,
    val inhaleSeconds: Int = 4,
    val holdSeconds: Int = 4,
    val exhaleSeconds: Int = 6,
    val restSeconds: Int = 2,
    val remindersEnabled: Boolean = false,
    val reminderIntervalMinutes: Int = 60
) {
    fun durationFor(phase: Phase): Int = when (phase) {
        Phase.Inhale -> inhaleSeconds
        Phase.Hold -> holdSeconds
        Phase.Exhale -> exhaleSeconds
        Phase.Rest -> restSeconds
    }

    fun save(context: Context) {
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit()
            .putInt("cycles", cycles)
            .putInt("inhale", inhaleSeconds)
            .putInt("hold", holdSeconds)
            .putInt("exhale", exhaleSeconds)
            .putInt("rest", restSeconds)
            .putBoolean("reminders", remindersEnabled)
            .putInt("reminderInterval", reminderIntervalMinutes)
            .apply()
    }

    companion object {
        fun load(context: Context): BreathingSettings {
            val prefs: SharedPreferences = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            return BreathingSettings(
                cycles = prefs.getInt("cycles", 4),
                inhaleSeconds = prefs.getInt("inhale", 4),
                holdSeconds = prefs.getInt("hold", 4),
                exhaleSeconds = prefs.getInt("exhale", 6),
                restSeconds = prefs.getInt("rest", 2),
                remindersEnabled = prefs.getBoolean("reminders", false),
                reminderIntervalMinutes = prefs.getInt("reminderInterval", 60)
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun CalmTideApp() {
    val context = LocalContext.current
    val reduceMotion = remember { systemAnimationsDisabled(context) }
    var settings by remember { mutableStateOf(BreathingSettings.load(context)) }
    var inSession by remember { mutableStateOf(false) }
    var showAbout by remember { mutableStateOf(false) }

    LaunchedEffect(settings) {
        settings.save(context)
        if (settings.remindersEnabled) {
            scheduleReminder(context, settings.reminderIntervalMinutes)
        } else {
            cancelReminder(context)
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("CalmTide") },
                actions = {
                    TextButton(onClick = { showAbout = true }) {
                        Text("About")
                    }
                }
            )
        }
    ) { padding ->
        if (inSession) {
            BreathingSessionScreen(
                settings = settings,
                onEnd = { inSession = false },
                modifier = Modifier.padding(padding)
            )
        } else {
            DashboardScreen(
                settings = settings,
                onSettingsChange = { settings = it },
                onStart = { inSession = true },
                modifier = Modifier.padding(padding)
            )
        }
    }

    if (showAbout) {
        AboutDialog(onDismiss = { showAbout = false })
    }
}

@Composable
private fun DashboardScreen(
    settings: BreathingSettings,
    onSettingsChange: (BreathingSettings) -> Unit,
    onStart: () -> Unit,
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current
    var notificationStatus by remember { mutableStateOf(permissionStatus(context)) }
    val permissionLauncher = rememberLauncherForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { granted ->
        notificationStatus = if (granted) "Reminders are allowed" else "Reminder permission was not allowed"
        onSettingsChange(settings.copy(remindersEnabled = granted && settings.remindersEnabled))
    }

    Column(
        modifier = modifier
            .fillMaxSize()
            .background(Brush.verticalGradient(listOf(Color(0xFF08233A), Color(0xFF0D615E))))
            .verticalScroll(rememberScrollState())
            .padding(20.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        Text(
            text = "Guided breathing with a soft tide rhythm.",
            style = MaterialTheme.typography.headlineSmall,
            color = Color.White,
            fontWeight = FontWeight.SemiBold
        )

        TidePoolBreathingView(phase = Phase.Rest, isPaused = true, reduceMotion = reduceMotion)

        SettingsCard(title = "Session") {
            StepperRow(
                label = "Cycles",
                value = settings.cycles,
                range = 1..12,
                onChange = { onSettingsChange(settings.copy(cycles = it)) }
            )
        }

        SettingsCard(title = "Phase Durations") {
            StepperRow("Inhale", settings.inhaleSeconds, 2..12) {
                onSettingsChange(settings.copy(inhaleSeconds = it))
            }
            StepperRow("Hold", settings.holdSeconds, 0..12) {
                onSettingsChange(settings.copy(holdSeconds = it))
            }
            StepperRow("Exhale", settings.exhaleSeconds, 2..16) {
                onSettingsChange(settings.copy(exhaleSeconds = it))
            }
            StepperRow("Rest", settings.restSeconds, 0..12) {
                onSettingsChange(settings.copy(restSeconds = it))
            }
        }

        SettingsCard(title = "Reminders") {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column(modifier = Modifier.weight(1f)) {
                    Text("Local reminders", color = Color.White, fontWeight = FontWeight.Medium)
                    Text(notificationStatus, color = Color(0xFFB9D8D2), style = MaterialTheme.typography.bodySmall)
                }
                Switch(
                    checked = settings.remindersEnabled,
                    onCheckedChange = { enabled ->
                        if (enabled && Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
                            ContextCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED
                        ) {
                            onSettingsChange(settings.copy(remindersEnabled = true))
                            permissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
                        } else {
                            onSettingsChange(settings.copy(remindersEnabled = enabled))
                            notificationStatus = if (enabled) "Reminders are scheduled locally" else "Reminders are off"
                        }
                    }
                )
            }

            Text(
                "Every ${settings.reminderIntervalMinutes} minutes",
                color = Color.White,
                modifier = Modifier.padding(top = 12.dp)
            )
            Slider(
                value = settings.reminderIntervalMinutes.toFloat(),
                onValueChange = {
                    onSettingsChange(settings.copy(reminderIntervalMinutes = it.roundToInt().coerceIn(15, 180)))
                },
                valueRange = 15f..180f,
                steps = 10
            )
        }

        Text(
            text = "Ready for ${settings.cycles} cycles, about ${formatDuration(settings)}.",
            color = Color(0xFFD8F3EC),
            textAlign = TextAlign.Center,
            modifier = Modifier.fillMaxWidth()
        )

        Button(
            onClick = onStart,
            modifier = Modifier
                .fillMaxWidth()
                .height(54.dp)
        ) {
            Text("Start Breathing")
        }
    }
}

@Composable
private fun BreathingSessionScreen(
    settings: BreathingSettings,
    onEnd: () -> Unit,
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current
    val reduceMotion = remember { systemAnimationsDisabled(context) }
    var cycle by remember { mutableIntStateOf(1) }
    var phase by remember { mutableStateOf(Phase.Inhale) }
    var secondsLeft by remember(settings, phase) { mutableIntStateOf(settings.durationFor(phase).coerceAtLeast(1)) }
    var paused by remember { mutableStateOf(false) }

    LaunchedEffect(settings, phase, paused, cycle) {
        while (!paused && secondsLeft > 0) {
            delay(1000)
            secondsLeft -= 1
        }
        if (!paused && secondsLeft == 0) {
            val next = nextPhase(phase)
            if (phase == Phase.Rest && cycle >= settings.cycles) {
                onEnd()
            } else {
                if (phase == Phase.Rest) cycle += 1
                phase = next
                secondsLeft = settings.durationFor(next).coerceAtLeast(1)
            }
        }
    }

    Column(
        modifier = modifier
            .fillMaxSize()
            .background(Brush.verticalGradient(listOf(Color(0xFF061A2A), Color(0xFF0B5755))))
            .padding(20.dp),
        verticalArrangement = Arrangement.spacedBy(18.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text("Cycle $cycle of ${settings.cycles}", color = Color(0xFFB9D8D2))

        TidePoolBreathingView(phase = phase, isPaused = paused, reduceMotion = reduceMotion)

        Text(
            text = phase.label,
            style = MaterialTheme.typography.displaySmall,
            color = Color.White,
            fontWeight = FontWeight.Bold
        )
        Text(phase.cue, color = Color(0xFFD8F3EC))
        Text(
            text = secondsLeft.toString(),
            style = MaterialTheme.typography.displayLarge,
            color = Color.White,
            fontWeight = FontWeight.Bold
        )

        Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
            Button(onClick = { paused = !paused }) {
                Text(if (paused) "Resume" else "Pause")
            }
            OutlinedButton(
                onClick = {
                    val next = nextPhase(phase)
                    if (phase == Phase.Rest) cycle = (cycle + 1).coerceAtMost(settings.cycles)
                    phase = next
                    secondsLeft = settings.durationFor(next).coerceAtLeast(1)
                }
            ) {
                Text("Skip")
            }
        }

        Spacer(modifier = Modifier.weight(1f))

        OutlinedButton(
            onClick = onEnd,
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("End Session")
        }
    }
}

@Composable
private fun TidePoolBreathingView(
    phase: Phase,
    isPaused: Boolean,
    reduceMotion: Boolean,
    modifier: Modifier = Modifier
) {
    val transition = rememberInfiniteTransition(label = "tide")
    val wave by transition.animateFloat(
        initialValue = 0f,
        targetValue = 1f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 4200, easing = LinearEasing),
            repeatMode = RepeatMode.Restart
        ),
        label = "wave"
    )
    val stillWave = when (phase) {
        Phase.Inhale -> 0.35f
        Phase.Hold -> 0.55f
        Phase.Exhale -> 0.75f
        Phase.Rest -> 0.15f
    }
    val progress = if (isPaused || reduceMotion) stillWave else wave

    Box(
        modifier = modifier
            .fillMaxWidth()
            .height(240.dp)
            .semantics { contentDescription = "Animated tide pool breathing visual" },
        contentAlignment = Alignment.Center
    ) {
        Canvas(modifier = Modifier.fillMaxSize()) {
            drawTidePool(progress, phase)
        }
    }
}

private fun DrawScope.drawTidePool(progress: Float, phase: Phase) {
    drawCircle(
        brush = Brush.radialGradient(
            listOf(Color(0xFF97F0DD), Color(0xFF0F807A), Color(0xFF08233A)),
            center = center,
            radius = size.minDimension * 0.55f
        ),
        radius = size.minDimension * 0.42f,
        center = center
    )

    val level = when (phase) {
        Phase.Inhale -> 0.42f
        Phase.Hold -> 0.48f
        Phase.Exhale -> 0.57f
        Phase.Rest -> 0.62f
    }
    val baseY = size.height * level
    val amplitude = size.height * 0.035f
    val path = Path().apply {
        moveTo(0f, baseY)
        for (x in 0..size.width.toInt() step 8) {
            val y = baseY + sin((x / size.width * 2f * PI + progress * 2f * PI)).toFloat() * amplitude
            lineTo(x.toFloat(), y)
        }
        lineTo(size.width, size.height)
        lineTo(0f, size.height)
        close()
    }
    drawPath(path, Color(0xAA7BE3D4))

    drawOval(
        color = Color(0x44FFFFFF),
        topLeft = Offset(size.width * 0.25f, size.height * 0.22f),
        size = Size(size.width * 0.5f, size.height * 0.12f)
    )
}

@Composable
private fun SettingsCard(title: String, content: @Composable Column.() -> Unit) {
    Card(
        colors = CardDefaults.cardColors(containerColor = Color(0x33204450)),
        shape = RoundedCornerShape(8.dp),
        modifier = Modifier.fillMaxWidth()
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            Text(title, color = Color.White, fontWeight = FontWeight.SemiBold)
            content()
        }
    }
}

@Composable
private fun StepperRow(label: String, value: Int, range: IntRange, onChange: (Int) -> Unit) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(label, color = Color.White)
        Row(verticalAlignment = Alignment.CenterVertically) {
            OutlinedButton(onClick = { onChange((value - 1).coerceAtLeast(range.first)) }) {
                Text("-")
            }
            Text(
                "$value",
                color = Color.White,
                textAlign = TextAlign.Center,
                modifier = Modifier.width(44.dp)
            )
            OutlinedButton(onClick = { onChange((value + 1).coerceAtMost(range.last)) }) {
                Text("+")
            }
        }
    }
}

@Composable
private fun AboutDialog(onDismiss: () -> Unit) {
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("About CalmTide") },
        text = {
            Text(
                "CalmTide is a guided breathing app with local settings, local reminders, and a soft tide visual. " +
                    "It is for relaxation and general wellbeing, not medical treatment. No account is required."
            )
        },
        confirmButton = {
            TextButton(onClick = onDismiss) {
                Text("Done")
            }
        }
    )
}

@Composable
private fun CalmTideTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = darkColorScheme(
            primary = Color(0xFF7BE3D4),
            secondary = Color(0xFFFFD89A),
            background = Color(0xFF061A2A),
            surface = Color(0xFF0B2E3B)
        ),
        content = {
            Surface(color = MaterialTheme.colorScheme.background, content = content)
        }
    )
}

private fun nextPhase(phase: Phase): Phase = when (phase) {
    Phase.Inhale -> Phase.Hold
    Phase.Hold -> Phase.Exhale
    Phase.Exhale -> Phase.Rest
    Phase.Rest -> Phase.Inhale
}

private fun formatDuration(settings: BreathingSettings): String {
    val secondsPerCycle = settings.inhaleSeconds + settings.holdSeconds + settings.exhaleSeconds + settings.restSeconds
    val totalSeconds = secondsPerCycle * settings.cycles
    val minutes = totalSeconds / 60
    val seconds = totalSeconds % 60
    return if (minutes > 0) "${minutes}m ${seconds}s" else "${seconds}s"
}

private fun permissionStatus(context: Context): String {
    return if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU ||
        ContextCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED
    ) {
        "Reminders can be scheduled locally"
    } else {
        "Reminder permission has not been granted"
    }
}

private fun systemAnimationsDisabled(context: Context): Boolean {
    val scale = Settings.Global.getFloat(
        context.contentResolver,
        Settings.Global.ANIMATOR_DURATION_SCALE,
        1f
    )
    return scale == 0f
}

private fun createReminderChannel(context: Context) {
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

    val channel = NotificationChannel(
        CHANNEL_ID,
        "CalmTide reminders",
        NotificationManager.IMPORTANCE_DEFAULT
    ).apply {
        description = "Gentle reminders to take a CalmTide breathing break"
    }

    context.getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
}

@SuppressLint("MissingPermission")
private fun sendReminderNotification(context: Context) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
        ContextCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED
    ) {
        return
    }

    val launchIntent = Intent(context, MainActivity::class.java)
    val pendingIntent = PendingIntent.getActivity(
        context,
        0,
        launchIntent,
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )

    val notification = NotificationCompat.Builder(context, CHANNEL_ID)
        .setSmallIcon(android.R.drawable.ic_dialog_info)
        .setContentTitle("CalmTide")
        .setContentText("Take a quiet minute to breathe with the tide.")
        .setContentIntent(pendingIntent)
        .setAutoCancel(true)
        .build()

    NotificationManagerCompat.from(context).notify(REQUEST_CODE_REMINDER, notification)
}

private fun scheduleReminder(context: Context, minutes: Int) {
    val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
    val pendingIntent = reminderPendingIntent(context)
    val triggerAt = System.currentTimeMillis() + minutes.coerceAtLeast(15) * 60_000L
    alarmManager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAt, pendingIntent)
}

private fun cancelReminder(context: Context) {
    val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
    alarmManager.cancel(reminderPendingIntent(context))
}

private fun reminderPendingIntent(context: Context): PendingIntent {
    val intent = Intent(context, ReminderReceiver::class.java).setAction(ACTION_REMINDER)
    return PendingIntent.getBroadcast(
        context,
        REQUEST_CODE_REMINDER,
        intent,
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )
}
