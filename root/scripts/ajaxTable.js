/**
 * the catalyst server address
 */
var serverAddress = 'localhost';
/**
 * the catalyst server port
 */
var serverPort = '3000';
/**
 * the webapp's context
 */
var monoideaContext = 'monoservice';
/**
 * the page's table id counter
 */
var tableCounter = 0;
/**
 * the table's row id counter
 */
var rowCounter = 0;

var tables = [{
    ajaxTable: null,
    htmlCallbacks: null,
    dataPoll: null
}];

function TableFactory(){
    this.createTable = createTable;
    
    function createTable(t){
	var row;
	
	switch(t){
	case "Download":
	    row = new Download();
	    break;
	}
	row.isDefaultRow = true;
	row.columns[0].ID[0].value = "*";

	tables[0].ajaxTable = new AjaxTable($("#content_0"),  row, 0);
	tables[0].htmlCallbacks = new AjaxTableHtmlCallbacks(0);

	tables[0].ajaxTable.insertRow(null, -1);
    }
}

function AjaxRow(){
    this.row = null;
    this.isDefaultRow = false;
    this.rowId = -1;
    this.validate = validate;
    
    function validate(rule){
	if(rule === null){
	    return(true);
	}
	
	/* 1st priority */
	var ruleAnd =  /([\(]?(([\w]+)(\=\=|\!\=|\<\=|\>\=|\<|\>)([\d]+|null))( \&\& ([\w]+)(\=\=|\!\=|\<\=|\>\=|\<|\>)([\d]+|null))[\)]?)+/g.exec(rule);
	var ruleAndValues = [];
	var andVal = [];
	var i = 0;
	var j = 0;
	
	for(mRuleAnd in ruleAnd){
	    var boolVal = /(([\w]+)(\=\=|\!\=|\<\=|\>\=|\<|\>)([\d]+|null))/g.exec(mRuleAnd);
	    andVal[j] = true;
	    
	    for(mBoolVal in boolVal){
		boolValField = /([\w]+)/g.exex(mBoolVal);
		boolValOperator = /(\=\=|\!\=|\<\=|\>\=|\<|\>)/g.exec(mBoolVal);
		boolValRange = /([\d]+||null)/.exec(mBoolVal);
		
		switch(boolValOperator){
		case "==":
		    if(this[boolValField] == boolValRange){
			ruleAndValues[i] = true;
		    }else{
			ruleAndValues[i] = false;
		    }
		    break;
		case "!=":
		    if(this[boolValField] != boolValRange){
			ruleAndValues[i] = true;
		    }else{
			ruleAndValues[i] = false;
		    }
		    break;
		case "<=":
		    if(this[boolValField] <= boolValRange){
			ruleAndValues[i] = true;
		    }else{
			ruleAndValues[i] = false;
		    }
		    break;
		case ">=":
		    if(this[boolValField] >= boolValRange){
			ruleAndValues[i] = true;
		    }else{
			ruleAndValues[i] = false;
		    }
		    break;
		case "<":
		    if(this[boolValField] < boolValRange){
			ruleAndValues[i] = true;
		    }else{
			ruleAndValues[i] = false;
		    }
		    break;
		case ">":
		    if(this[boolValField] > boolValRange){
			ruleAndValues[i] = true;
		    }else{
			ruleAndValues[i] = false;
		    }
		    break;
		}
		
		if(!ruleAndValues[i] && andVal[j]){
		    andVal[j] = false;
		}
		
		i++;
	    }
	    
	    j++;
	}
	
	/* substitute */
	var str = rule;
	var result;
	i = 0;
	
	while((result = /([\(]?(([\w]+)(\=\=|\!\=|\<\=|\>\=|\<|\>)([\d]+|null))( \&\& ([\w]+)(\=\=|\!\=|\<\=|\>\=|\<|\>)([\d]+|null))[\)]?)+/g.exec(str)) != null){
	    var addBrackets = false;
	    
	    if(str[0] == '('){
		addBrackets = true;
	    }

	    if(result.index == 0){
		str = andVal[i] + "&&" + str.substr(result.lastIndex, str.length - (result.lastIndex - result.index));
	    }else{
		str = str.substr(0, result.index) + andVal[i] + "&&" + str.substr(result.lastIndex, str.length - (result.lastIndex - result.index));
	    }
	    
	    if(addBrackets){
		str = "(" + str + ")";
	    }
	    
	    i++;
	}
	
	str = str.replace("&&)", "");
	
	/* 2nd priority */
	var ruleOr =  /([\(]?(([\w]+)(\=\=|\!\=|\<\=|\>\=|\<|\>)([\d]+|null))|(true|false)( \|\| ([\w]+)(\=\=|\!\=|\<\=|\>\=|\<|\>)([\d]+|null))[\)]?)+/g.exec(str);
	var ruleOrValues = [];
	var orVal = [];
	i = 0;
	j = 0;
	
	for(mRuleOr in ruleOr){
	    var boolVal = /(([\w]+)(\=\=|\!\=|\<\=|\>\=|\<|\>)([\d]+|null))/g.exec(mRuleOr);
	    orVal[j] = false;
	    
	    for(mBoolVal in boolVal){
		boolValField = /([\w]+)/g.exex(mBoolVal);
		boolValOperator = /(\=\=|\!\=|\<\=|\>\=|\<|\>)/g.exec(mBoolVal);
		boolValRange = /([\d]+|null)/.exec(mBoolVal);
		
		switch(boolValOperator){
		case "==":
		    if(this[boolValField] == boolValRange){
			ruleOrValues[i] = true;
		    }else{
			ruleOrValues[i] = false;
		    }
		    break;
		case "!=":
		    if(this[boolValField] != boolValRange){
			ruleOrValues[i] = true;
		    }else{
			ruleOrValues[i] = false;
		    }
		    break;
		case "<=":
		    if(this[boolValField] <= boolValRange){
			ruleOrValues[i] = true;
		    }else{
			ruleOrValues[i] = false;
		    }
		    break;
		case ">=":
		    if(this[boolValField] >= boolValRange){
			ruleOrValues[i] = true;
		    }else{
			ruleOrValues[i] = false;
		    }
		    break;
		case "<":
		    if(this[boolValField] < boolValRange){
			ruleOrValues[i] = true;
		    }else{
			ruleOrValues[i] = false;
		    }
		    break;
		case ">":
		    if(this[boolValField] > boolValRange){
			ruleOrValues[i] = true;
		    }else{
			ruleOrValues[i] = false;
		    }
		    break;
		}
		
		if(ruleOrValues[i] && !orVal[j]){
		    orVal[j] = true;
		}
		
		i++;
	    }
	    
	    j++;
	}
	
	/* substitute */
	i = 0;
	
	while((result = /([\(]?(([\w]+)(\=\=|\!\=|\<\=|\>\=|\<|\>)([\d]+|null))|(true|false)( \|\| ([\w]+)(\=\=|\!\=|\<\=|\>\=|\<|\>)([\d]+|null))[\)]?)+/g.exec(str)) != null){
	    var addBrackets = false;
	    
	    if(str[0] == '('){
		addBrackets = true;
	    }
	    
	    if(result.index == 0){
		str = orVal[i] + "||" + str.substr(result.lastIndex, str.length - (result.lastIndex - result.index));
	    }else{
		str = str.substr(0, result.index) + orVal[i] + "||" + str.substr(result.lastIndex, str.length - (result.lastIndex - result.index));
	    }
	    
	    if(addBrackets){
		str = "(" + str + ")";
	    }
	    
	    i++;
	}
	
	str = str.replace("||)", "");
	
	/* solve */
	var solverStr = str;
	var offset;
	
	while((offset = solverStr.indexOf(")")) != -1){
	    /* find levels */
	    i = 0;
	    
	    while(solverStr[offset - i] != '('){
		i++;
	    }

	    var start = offset - i;
	    
	    /* evaluate */
	    var tmp = solverStr.substring(start, offset);
	    
	    if(tmp.match("(false\&\&false)|(true\&\&false)|(false\&\&true)|") != null){
		return(false);
	    }
	    
	    solverStr = solverStr.substring(0, start) + solverStr.substring(offset, solverStr.length - 1);
	}
	
	if(solverStr.match("(false\&\&false)|(true\&\&false)|(false\&\&true)") != null){
	    return(false);
	}else{
	    if(solverStr == "false"){
		return(false);
	    }else{
		return(true);
	    }
	}
    }
    
    rowId = rowCounter;
}

function ContextRow(){
    this.columns = [{
	ID: [{
	    defaultValue: "*",
	    inputType: "text",
	    value: null
	}], Protocol:  [{
	    defaultValue: null,
	    inputType: "text",
	    value: null
	}], Address:  [{
	    defaultValue: null,
	    inputType: "text",
	    value: null
	}]
    }];
}

ContextRow.prototype = new AjaxRow();

/**
 * the column index enumeration of download
 */
function DownloadRow(){
    this.columns = [{
	ID: [{
	    defaultValue: "*",
	    inputType: "text",
	    value: null
	}], SessionID:  [{
	    defaultValue: null,
	    inputType: "text",
	    value: null
	}], Token:  [{
	    defaultValue: null,
	    inputType: "text",
	    value: null
	}], VideoFileID:  [{
	    defaultValue: null,
	    inputType: "text",
	    value: null
	}]
    }];
}

DownloadRow.prototype = new AjaxRow();

function AjaxTable(p, r, i){
    this.table = null;
    this.rows = r;
    this.index = i;
    this.tableId = 0;
    this.insertRow = insertRow;
    this.removeRow = removeRow;
    this.resetLastRow = resetLastRow;
    this.rowData = null;
    this.validationRule = null;
    
    /**
     * @param row 
     * @param position
     * 
     * Inserts the row at the given position.
     */
    function insertRow(row, position){
	if(table === null){
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
	var rowTemplate = "<tr id=\"row_" + rowCounter + "\"><td><input class=\"htmlCallbacks.actionCheckbox\" type=\"checkbox\" /></td>";
	
	/* increment id-counter */
	$("#row_" + rowCounter);
	row.rowId = rowCounter;
	rowCounter++;
	
	/* iterate columns */
	var entry = row.columns[0];
	var name;
	var i = 0;
	
	for(name in entry){
	    var col = row.columns[0][name];
	    var val = "";
	    
	    if(col[0].value != null){
		val = col[0].value;
	    }
	    
	    if(row.isDefaultRow){
		rowTemplate += "<td><input type=\"" + col[0].inputType + "\" value=\"" + val + "\" onchange=\"tables[" + index + "]\.htmlCallbacks\.addRow(\$('#table_" + (this.tableId) + "'), \$('#row_" + (rowCounter - 1) + "'), " + i + ")\"/></td>";
	    }else{
		rowTemplate += "<td><input type=\"" + col[0].inputType + "\" value=\"" + val + "\" onchange=\"tables[" + index + "]\.htmlCallbacks\.changeRow(\$('#table_" + (this.tableId) + "'), \$('#row_" + (rowCounter - 1) + "'), " + i + ")\"/></td>";
	    }
	    
	    i++;
	}
	
	rowTemplate += "</tr>";
	
	$(rowTemplate).insertAfter("#table_" + this.tableId + " tr:eq(" + (position) + ")");
    }
    
    /**
     * @param row
     * 
     * Removes the row from the table.
     */
    function removeRow(row){
	if(table === null){
	    return;
	}
	
	if(position == -1){
	    if(this.rowData === null){
		return;
	    }else{
		position = this.rowData.length;
	    }
	}
	
	if(row === null){
	    return;
	}
	
	this.rowData[table.index(row)] = null;
	row.row.remove();
    }
    
    /**
     * resets the last row
     */
    function resetLastRow(){
	/* iterate columns */
	var entry = this.rows.columns[0];
	var name;
	var i = 0;
	
	for(name in entry){
	    var col = this.rows.columns[0][name];
	    
	    col[0].value = col[0].defaultValue;
	    
	    $( "#table_" + this.tableId + " tr:last td:eq(" + (i + 1) + ") input").val(col[0].defaultValue);
	    
	    i++;
	}
    }
    
    /**
     * unselectes checkboxes
     */
    function unselectActionCheckbox(){
	this.table[0]('.actionCheckbox').attr('checked', false);
    }
    
    /**
     * @param parent
     * 
     * Creates the initial table and packs it to parent.
     */
    function createTable(parent){
	var tableTemplate = "<table id=\"table_" + tableCounter + "\"></table>";
	
	if(parent === null){
	    $(document).append(tableTemplate).addClass("orphan");
	}else{
	    parent.append(tableTemplate);
	}
	
	/* increment id-counter */
	table = $("#table_" + tableCounter);
	tableCounter++;

	table.addClass("dbTable");
	
	/* add header */
	var rowTemplate = "<tr><td><strong>select</strong></td>";
	
	var entry = this.rows.columns[0];
	var name;
	
	for(name in entry){
	    rowTemplate += "<td><strong>" + name + "</strong></td>";
	}
	
	rowTemplate += "</tr>";
	
	table.append(rowTemplate);
    }

    rows = r;
    index = i;
    tableId = tableCounter;
}

function AjaxTableHtmlCallbacks(i){
    this.index = i;
    this.addRow = addRow;
    this.changeRow = changeRow;
    this.actionDelete = actionDelete;

    /**
     * @param table the table to change
     * @param row the row containing the changed value
     * @param the column index it triggered
     * 
     * Add a row to the specific table. Is a callback of AjaxTable.
     */
    function addRow(table, row, colNum){
	/* check if all required fields are filled */
	if(!tables[this.index].ajaxTable.rows.validate(tables[this.index].ajaxTable.validationRule)){
	    return;
	}
	
	/* update default row */
	var entry = tables[this.index].ajaxTable.rows.columns[0];
	var name;
	var i = 0;
	for(name in entry){
	    if(i === colNum)
		break;
	    i++;
	};
	
	var tableId = tables[this.index].ajaxTable.tableId;
	var cellValue = $("#table_" + tableId + " tr:last td:eq(" + (colNum + 1) + ") input").prop("value");
	tables[index].ajaxTable.rows.columns[0][name][0].value = cellValue;
	
	/* list HTTP parameters */
	params = {};

	/* submit the data */
	//submitChangeRecord(params);

	/* add new row */
	//var newRow =  [];
	var newRow = $().extend(true, {}, tables[this.index].ajaxTable.rows);
	newRow.isDefaultRow = false;
	
	var lastPosition = 0;
	
	if(tables[this.index].ajaxTable.rowData != null){
	    lastPosition = tables[this.index].ajaxTable.rowData.length;
	}
	
	tables[this.index].ajaxTable.insertRow(newRow,  lastPosition);
	
	/* reset last row */
	tables[this.index].ajaxTable.resetLastRow();
    }

    /**
     * @param table the altered table
     * @param cell the cell containing the new value
     * @param recordName the column name
     * @param recordValue the cell's value
     * 
     * Change a field's value. Intended to be used
     * as callback.
     */
    function changeRow(table, cell, recordName, recordValue){
	var controller;
	var recordId;
	var tmp;

	controller = findMappingForTable(table);

	tmp = cell.parentNode.parentNode.getAttribute("id");
	recordId = /record-([\d]+)/g.exec(tmp)[1];

	submitChangeRecord(controller, recordId, recordName, recordValue);
    }

    /**
     * @param table the table to delete the records in.
     * 
     * Deletes the selected rows.
     */
    function actionDelete(table){
	var controller;
	var recordHtmlId;
	var recordId;
	var form;
	var current;

	form = document.getElementById(table + 'Form');
	controller = findMappingForTable(table);

	for(var i = form.length - 1; i >= 0; i--){
	    current = form.elements[i];

	    if(current.type == 'checkbox' && current.className === 'actionCheckbox' && current.checked === true){
		recordHtmlId = current.parentNode.parentNode.getAttribute('id');
		recordId = /record-([\d]+)/g.exec(recordHtmlId)[1];

		submitDeleteRecord(controller, recordId, function(recordId){
		    //checkbox.checked = false;
		    $('#record-' + recordId).remove();

		    //if(i === 0){
		    //unselectActionCheckbox();
		    //}
		});
	    }
	}

	return(false);
    }
}

HttpRequestParameter = [{
    name: null,
    value: null
}];

function WebService(){
    this.getXMLHttpRequest = getXMLHttpRequest;
    this.checkParameter = checkParameter;
    this.encodeFormData = encodeFormData;
    this.submitCreateRecord = submitCreateRecord;
    this.submitDeleteRecord = submitDeleteRecord;
    this.submitChangeRecord = submitChangeRecord;

    /**
     * @returns http request
     * 
     * Retrieve a http request object.
     */
    function getXMLHttpRequest(){
	if(window.XMLHttpRequest){
	    //firefox, opera, safari, ...
	    return(new XMLHttpRequest);
	}else{
	    if(window.ActiveXObject){
		// ie

		try{
		    return(new ActiveXObject('Msxml2.XMLHTTP.6.0'));
		}catch(e1){
		    try{
			return(new ActiveXObject('Msxml2.XMLHTTP.3.0'));
		    }catch(e2){
			return(null);
		    }
		}
	    }
	}

	return(null);
    }

    /**
     * @param table the table to synchronize
     * 
     * Check's for new data and reload's the page if necessary.
     */
    function checkParameter(row, params){
	/* iterate columns */
	var entry = row.columns[0];
	var name;
	var i = 0;

	for(name in entry){
	    var col = row.columns[0][name];

	    if(col.isRequired && col.value == null){
		return(false);
	    }
	}

	return(true);
    }

    /**
     * @param data a JSON object
     * 
     * Encode JSON object to HTTP form data.
     */
    function encodeFormData(data) {
	if (!data) return ""; // Always return a string
	var pairs = []; // To hold name=value pairs

	var i;

	for(i = 0; i < data.length; i++){
	    for(var name in data[i]) { // For each name
		if (!data[i].hasOwnProperty(name)) continue; // Skip inherited
		if (typeof data[i][name] === "function") continue; // Skip methods
		var value = data[i][name].toString(); // Value as string
		name = encodeURIComponent(name.replace(" ", "+")); // Encode name
		value = encodeURIComponent(value.replace(" ", "+")); // Encode value

		pairs.push(name + "=" + value); // Remember name=value pair
	    }
	}

	return pairs.join('&'); // Return joined pairs separated with &
    }

    /**
     * @param controller the controller mapping
     * @returns {Number}
     * 
     * Create a record.
     */
    function submitCreateRecord(controller, params, callback){
	var req;

	req = getXMLHttpRequest();

	if(req != null){
	    var encodedData;

	    /* create form data */
	    data = [{
		command: 'create-record'
	    }];
	    data.concat(params); 

	    /* open HTTP request */
	    req.open('POST', 'http://' + serverAddress + ':' + serverPort + '/' + monoideaContext + '/' + controller, true);
	    req.onreadystatechange = function(){
		if(req.readyState === 4 && req.status === 200){
		    var body;
		    var type;

		    /* check response type */
		    type = req.getResponseHeader('Content-Type');

		    if(type === 'application/xml'){
			/* receive record id and return it */
			var recordId;

			body = req.responseText;
			recordId = /<entry name="id">([\d]+)<\/entry>/g.exec(body)[1];

			callback(recordId);

			return(recordId);
		    }
		}
	    };
	    req.setRequestHeader('Content-Type',
				 'application/x-www-form-urlencoded');

	    /* submit form data */
	    encodedData = encodeFormData(data)

	    req.send(encodedData);
	}else{
	    return(-1);
	}
    }

    /**
     * @param controller the controller mapping
     * @param recordId the record to delete
     * 
     * Delete a record with recordId.
     */
    function submitDeleteRecord(controller, params, callback){
	var req;

	req = getXMLHttpRequest();

	if(req != null){
	    var encodedData;

	    /* create form data */
	    data = {
		command: 'delete-record',
	    };
	    data.concat(params);

	    /* open HTTP request */
	    req.open('POST', 'http://' + serverAddress + ':' + serverPort + '/' + monoideaContext + '/' + controller, true);
	    req.onreadystatechange = function(){
		if(req.readyState === 4 && req.status === 200){
		    var body;
		    var type;

		    /* check response type */
		    type = req.getResponseHeader('Content-Type');

		    if(type === 'application/xml'){
			body = req.responseText;

			callback(recordId);
		    }
		}
	    };
	    req.setRequestHeader('Content-Type',
				 'application/x-www-form-urlencoded');

	    /* submit form data */
	    encodedData = encodeFormData(data)

	    req.send(encodedData);
	}else{
	    return(-1);
	}
    }

    /**
     * @param controller the controller mapping
     * @param recordId the record's id
     * @param column the changed column
     * @param value the value entered
     * 
     * Does POST value to controller in column with recordId.
     */
    function submitChangeRecord(controller, params, callback){
	var req;

	req = getXMLHttpRequest();

	if(req != null){
	    var encodedData;

	    /* create form data */
	    data = [{
		command: 'set-field'
	    }];
	    data.concat(params);

	    /* open HTTP request */
	    req.open('POST', 'http://' + serverAddress + ':' + serverPort + '/' + monoideaContext + '/' + controller, true);
	    req.onreadystatechange = function(){
		if(req.readyState === 4 && req.status === 200){
		    var body;
		    var type;

		    /* check response type */
		    type = req.getResponseHeader('Content-Type');

		    if(type === 'application/xml'){
			body = req.responseText;

			//TODO:JK: do something fancy

			return(recordId);
		    }
		}
	    };
	    req.setRequestHeader('Content-Type',
				 'application/x-www-form-urlencoded');

	    /* submit form data */
	    encodedData = encodeFormData(data)

	    req.send(encodedData);
	}else{
	    return(-1);
	}
    }
}
