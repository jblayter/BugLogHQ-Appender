BugLogHQ-Appender
=================

An appender for the LogBox framework that sends the errors to the BugLogHQ project




Installation
------------



	logBox = {
		root = {
			levelMin=0,
			levelMax=4,
			appenders="GeneralAppender"
		},
		categories = {
			"general"	= {appenders="GeneralAppender"},
			"buglog"	= {appenders="BugLogAppender"}
		},
		appenders = {
			GeneralAppender = {
				class="coldbox.system.logging.appenders.CFAppender",
				properties={
					fileName="General"
				}
			},
			BugLogAppender = {
				class="com.blayter.logging.appenders.BugLogHQAppender",
				properties={
					bugLogListener="http://[ url to buglog domain ]/listeners/bugLogListenerREST.cfm",
					bugEmailRecipients="errors@yourdomain.com",
					bugEmailSender="noreply@yourdomain.com",
					apiKey="[ your api key ]",
					appName=coldbox.appname
				}
			}
		}
	};

