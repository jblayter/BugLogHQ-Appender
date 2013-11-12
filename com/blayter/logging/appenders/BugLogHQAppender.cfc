component extends="coldbox.system.logging.AbstractAppender" output="false" hint="An appender that sends out a BugLogHQ request"{

	public BugLogHQAppender function init(required name, required struct properties="#structNew()#", required numeric levelMin=0, required numeric levelMax=4) hint="Constructor" output="false"{
		// Init supertype
		super.init(argumentCollection=arguments);

		// Property Checks
		if( NOT propertyExists("bugLogListener") ){
			$throw(message="BugLogHQAppender the property bugLogListener is required",type="BugLogHQAppender.PropertyNotFound");
		}
		
		this.bugLogService = createObject("component","com.blayter.services.BugLogService").init(argumentCollection=arguments.properties);
		
		return this;
	}

	// Log Message
	public void function logMessage(required any logEvent) hint="Write an entry into the logger."{

		var extraInfo = structNew();
		var transactionId = "";
		
		try {
			if(isDefined("form"))
				{
				extraInfo.form	= form;
				}
			if(isDefined("url"))
				{
				extraInfo.url	= url;
				}	
			if(isDefined("client.schoolName"))
				{
				extraInfo._school.name = client.schoolName;
				}
			if(isDefined("client.partitionId"))
				{
				extraInfo._school.partitionId = client.partitionId;
				}
			if(isDefined("client.locale"))
				{
				extraInfo._school.locale = client.locale;
				}
			if(isDefined("client.username"))
				{
				extraInfo._user.username = client.username;
				}
			if(isDefined("client.ss.personId"))
				{
				extraInfo._user.personId = client.ss.personId;
				}
			if(isDefined("client.ss.userAccountId"))
				{
				extraInfo._user.userAccountId = client.ss.userAccountId;
				}
			if(NOT isDefined("arguments.exception.transactionId"))
				{
				arguments.exception.transactionId = createGuid();
				transactionId = arguments.exception.transactionId;
				}
			else
				{
				transactionId = arguments.exception.transactionId;
				}
			
			this.bugLogService.notifyService(
				message=arguments.logEvent.getMessage(),
				exception=arguments.logEvent.getExtraInfoAsString(),
				extraInfo=extraInfo,
				externalId=transactionId,
				severityCode=getSeverity(arguments.logEvent.getSeverity())
				);
		} catch (any e) {
			$log("ERROR","Error sending email from appender #getName()#. #e.message# #e.detail# #e.stacktrace#");
		}

	}
	
	private string function getSeverity(required numeric severity){
		switch(arguments.severity){
			case 0:
				var eventType = "FATAL";
				break;
			case 1:
				var eventType = "ERROR";
				break;
			case 2:
				var eventType = "WARN";
				break;
			case 3:
				var eventType = "INFO";
				break;
			default:
				var eventType = "DEBUG";
		}
		return eventType;
	}

}