package com.ninjageeksco.budget_manager

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class BudgetWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.budget_widget).apply {
                val budgetValue = widgetData.getString("budget_value", "$0.00")
                
                setTextViewText(R.id.widget_budget_value, budgetValue)
                
                // PendingIntent to launch the app when clicking the budget area
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(context, 
                    MainActivity::class.java, 
                    Uri.parse("budgetmanager://dashboard"))
                setOnClickPendingIntent(R.id.budget_info, pendingIntent)

                // PendingIntent for Quick Add button
                val addPendingIntent = HomeWidgetLaunchIntent.getActivity(context, 
                    MainActivity::class.java, 
                    Uri.parse("budgetmanager://add_transaction"))
                setOnClickPendingIntent(R.id.widget_add_button, addPendingIntent)
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
