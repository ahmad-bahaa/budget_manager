package com.ninjageeksco.budget_manager

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray
import org.json.JSONObject

class BudgetWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.budget_widget).apply {
                val categoriesJson = widgetData.getString("categories_data", "[]")
                val categoriesArray = JSONArray(categoriesJson)
                
                val itemIds = arrayOf(R.id.item_1, R.id.item_2, R.id.item_3, R.id.item_4)
                
                if (categoriesArray.length() == 0) {
                    setViewVisibility(R.id.widget_empty_text, View.VISIBLE)
                    for (id in itemIds) setViewVisibility(id, View.GONE)
                } else {
                    setViewVisibility(R.id.widget_empty_text, View.GONE)
                    
                    val nameIds = arrayOf(R.id.item_name_1, R.id.item_name_2, R.id.item_name_3, R.id.item_name_4)
                    val remainingIds = arrayOf(R.id.item_remaining_1, R.id.item_remaining_2, R.id.item_remaining_3, R.id.item_remaining_4)

                    for (i in 0 until 4) {
                        if (i < categoriesArray.length()) {
                            val category = categoriesArray.getJSONObject(i)
                            val name = category.getString("name")
                            val remaining = category.getString("remaining")
                            
                            setViewVisibility(itemIds[i], View.VISIBLE)
                            setTextViewText(nameIds[i], name)
                            setTextViewText(remainingIds[i], remaining)
                        } else {
                            setViewVisibility(itemIds[i], View.GONE)
                        }
                    }
                }

                // Standard app launch intent
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
