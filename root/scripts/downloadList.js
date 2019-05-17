/**
 * the page's list id counter
 */
var listCounter = 0;
/**
 * the page's session id
 */
var session_id;
/**
 * the page's token
 */
var token;
/**
 * the video's width
 */
var videoWidth;
/**
 * the video's height
 */
var videoHeight;

var lists = [{
    downloadList: null,
    htmlCallbacks: null,
    dataPoll: null
}];

function updateDOM(nth, xmlDoc){
    var downloadList = lists[nth].downloadList;

    var i;
    var i_stop;

    if(downloadList.rowData === null){
	i_stop = 0;
    }else{
	i_stop = downloadList.rowData.length;
    }

    for(i = 0; i < i_stop;){
	if(!$(xmlDoc).find("video-file-id:contains(" + downloadList.rowData[i].columns[0]["VideoFileID"][0].value + ")").length){
	    downloadList.removeItem(downloadList.rowData[i]);

	    i_stop--;
	}else{
	    i++;
	}
    }

    var media = $(xmlDoc).find("media");

    var child = media.children("video-file-id").each(function(){
	var id = $(this).text();

	if(!downloadList.findVideoFileID(id)){
	    var row = new DownloadItem();

	    row.columns[0]["SessionID"][0].value = session_id;
	    row.columns[0]["Token"][0].value = token;
	    row.columns[0]["VideoFileID"][0].value = id;

	    downloadList.insertItem(row, -1);
	}
    });
}

function DownloadListFactory(){
    this.createList = createList;
    
    function createList(t){
	var row;
	
	switch(t){
	case "Download":
	    break;
	}

	lists[0].downloadList =
	    tables[0].ajaxTable = new DownloadList($("#content_0"),  row, 0);

	lists[0].htmlCallbacks =
	    tables[0].htmlCallbacks = null;

	lists[0].dataPoll =
	    tables[0].DataPoll = new DownloadListService(0);

	lists[0].downloadList.createList($("#content_0"));

	setInterval(function(){
	    params = [{
		session_id: session_id,
		token: token
	    }];
	   
	    lists[0].dataPoll.pollData("download", params, updateDOM);
	}, 10000);
    }
}

function DownloadItem(){
}

DownloadItem.prototype = new DownloadRow();

function DownloadList(p, r, i){
    this.listId = 0;
    this.list = null;
    this.createList = createList;
    this.findVideoFileID = findVideoFileID;
    this.insertItem = insertItem;
    this.removeItem = removeItem;

    function findVideoFileID(id){
	var i;
	
	if(this.rowData === null){
	    return(false);
	}

	for(i = 0; i < this.rowData.length; i++){
	    if(this.rowData[i].columns[0]["VideoFileID"][0].value === id){
		return(true);
	    }
	}

	return(false);
    }

    /**
     * @param item 
     * @param position
     * 
     * Inserts the item at the given position.
     */
    function insertItem(row, position){
	if(list === null){
	    return;
	}
	
	if(position == -1){
	    if(this.rowData === null){
		position = 0;
	    }else{
		position = this.rowData.length;
	    }
	}
	
	if(row === null){
	    row = $().extend(true, {}, this.rows);
	}
	
	/* append rowData */
	if(row.isDefaultRow){
	    this.rows = row;
	}
	
	if(!row.isDefaultRow && !row.isHeader){
	    if(this.rowData === null){
		this.rowData = [];
	    }

	    this.rowData[position] = row;
	}
	
	/* fill HTML with data */
	var itemTemplate = "<li id=\"item_" + rowCounter + "\">";
	
	/* increment id-counter */
	$("#item_" + rowCounter);
	row.rowId = rowCounter;
	rowCounter++;
	
	/* iterate columns */
	var sessionIDCol = row.columns[0]["SessionID"];
	var tokenCol = row.columns[0]["Token"];
	var videoFileIDCol = row.columns[0]["VideoFileID"];

	itemTemplate += "<div><a href=\"http://" + serverAddress + ":" + serverPort + "/download/media?session_id=" + sessionIDCol[0].value + "&token=" + tokenCol[0].value + "&video_file_id=" + videoFileIDCol[0].value + "\">Download your Monothek Session</a></div>";


	itemTemplate += "<div><video width=\"" + videoWidth + "\" height=\"" + videoHeight + "\" controls><source src=\"http://" + serverAddress + ":" + serverPort + "/download/media?session_id=" + sessionIDCol[0].value + "&token=" + tokenCol[0].value + "&video_file_id=" + videoFileIDCol[0].value + "\" type=\"video/mp4\">Your browser does not support the video tag.</video></div>";

	
	itemTemplate += "</li>";
	
	if($("#list_" + listId + " li:eq(" + (position) + ")").length){
	    $("#list_" + listId + " li:eq(" + (position) + ")").after(itemTemplate);
	}else{
	    $("#list_" + listId).prepend(itemTemplate);
	}
    }

    /**
     * @param item
     * 
     * Removes the item from the list.
     */
    function removeItem(row){
	if(list === null){
	    return;
	}
	
	if(row === null){
	    return;
	}
	
	var row_index = this.rowData.indexOf(row);

	if(row_index > -1){
	    this.rowData.splice(row_index, 1);
	}
	
	$("#list_" + listId + " li:eq(" + row_index + ")").remove();

	//row.row.remove();
    }

    function createList(parent){
	var listTemplate = "<ul id=\"list_" + listCounter + "\"></ul>";
	
	if(parent === null){
	    $(document).append(listTemplate).addClass("orphan");
	}else{
	    parent.append(listTemplate);
	}
	
	/* increment id-counter */
	list = $("#list_" + listCounter);
	listCounter++;

	list.addClass("dbList");
    }

    rows = r;
    index = i;
    listId = listCounter;
}

DownloadList.prototype = new AjaxTable();

function DownloadListService(i){
    this.index = i;
    this.pollData = pollData;

    function pollData(controller, params, callback){
	var req;

	req = this.getXMLHttpRequest();

	if(req != null){
	    var encodedData;

	    /* create form data */
	    data = [{
		command: "list-record"
	    }];
	    var param_data = data.concat(params); 

	    /* open HTTP request */
	    req.open("POST", "http://" + serverAddress + ":" + serverPort + "/" + monoideaContext + "/" + controller, true);
	    req.onreadystatechange = function(){
		if(req.readyState === 4 && req.status === 200){
		    var body;
		    var type;

		    /* check response type */
		    type = req.getResponseHeader("Content-Type");

		    if(/application\/xml;/g.exec(type)){
			/* receive record id and return it */
			var xmlDoc;
			
			body = req.responseText;
			xmlDoc = $.parseXML( body );
			
			callback(index, xmlDoc);
		    }
		}
	    };
	    req.setRequestHeader("Content-Type",
				 "application/x-www-form-urlencoded");

	    /* submit form data */
	    encodedData = this.encodeFormData(param_data)

	    req.send(encodedData);
	}else{
	    return(-1);
	}
    }
}

DownloadListService.prototype = new WebService();
