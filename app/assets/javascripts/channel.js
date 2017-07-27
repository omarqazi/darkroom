function PreviewInstruction() {
    var instruction = $("#instruction_input_box").val();
	$.ajax({
		type: "POST",
		url: "http://localhost:8080/clips/darkroom-clip-preview",
		data: instruction
	}).done(function(data,jq,xhr) {
        console.log(data,jq,xhr);
    }).fail(function(data,jq,xhr) {
        console.log(data,jq,xhr);
    });
    
    var video = document.getElementById("channel_video")
    video.src = "http://localhost:8080/clips/darkroom-clip-preview.m3u8";
    video.play();
}

function QueueInstruction() {
    var instruction = $("#instruction_input_box").val();
    CallUpdateInstruction({instruction:instruction});
}

function RunInstruction() {
    var instruction = $("#instruction_input_box").val();
    CallUpdateInstruction({instruction:instruction,reset:"true"});
}

function RestartChannel() {
    CallUpdateInstruction({reset:"true"});
}

function CallUpdateInstruction(dataArg) {
    var url = "/channel/" + channelId + "/update_instruction";
    
	$.ajax({
		type: "POST",
		url: url,
		data: dataArg
	}).done(function(data,jq,xhr) {
        alert("Channel updated successfully");
        console.log(data,jq,xhr);
    }).fail(function(data,jq,xhr) {
        alert("Failed to update channel");
        console.log(data,jq,xhr);
    });
    
    UpdateStatusInformation();
}

function UpdateStatusInformation() {
    $.ajax({
        type: "GET",
        url: "/channel/" + channelId + ".json",
    }).done(function(data,jq,xhr) {
        console.log(data);
        GetNowPlaying(channelData);
    }).fail(function(data,jq,xhr) {
        GetNowPlaying(channelData); 
    });
}

function LoadChannelViews() {
    if(Hls.isSupported()) {
        var video = document.getElementById('channel_video');
        var hls = new Hls();
        hls.loadSource(channelData.streamUrl);
        hls.attachMedia(video);
        hls.on(Hls.Events.MANIFEST_PARSED,function() {
          video.play();
      });
     }
    GetNowPlaying(channelData);
    TickStatusUpdate();
}

function TickStatusUpdate() {
    setTimeout(function() {
        UpdateStatusInformation();
        TickStatusUpdate();
    },5000);
}

// Given a stream instruction, return information about the currently playing track
function GetNowPlaying(channel) {
    var functionName = channel.streamInstruction.function;
    if (functionName == "aws") {
        RenderAWSInstruction(channel.streamInstruction.instruction_string,"now_playing_item");
    } else if (functionName == "queue") {
        QuerySessionForNowPlaying(channel);
    } else if (functionName == "list") {
        alert("This is a list");
    } else if (functionName == "schedule") {
        alert("This is a schedule");
    } else if (functionName == "playlist") {
        alert("This is a playlist")
    } else if (functionName == "iterator") {
        alert("This is an iterator");
    }
}

function QuerySessionForNowPlaying(channel) {
    var guideChannelId = channel.guideId;
    var serverUrl = channel.guideServer;
    var args = channel.streamInstruction.args;
    
    var requestUrl = serverUrl + "streams/session/" + guideChannelId;
    $.ajax({
        type: "GET",
        url: requestUrl
    }).done(function(data,jq,xhr) {
        var ds = data;
        if (typeof data == "string") {
            ds = JSON.parse(data);
        }
        RenderAWSInstruction(ds.current_instruction,"now_playing_item");
    }).fail(function(data,jq,xhr) {
        console.log(data,jq,xhr); 
    });
    
    var queueUrl = serverUrl + "list/" + args.qid;
    $.ajax({
        type: "GET",
        url: queueUrl
    }).done(function(data,jq,xhr) {
        RenderAWSInstruction(data,"up_next_items");
    }).fail(function(data,jq,xhr) {
        console.log(data,jq,xhr);
    })
    
    
}

function RenderAWSInstruction(is,outputElement) {
    $.ajax({
        type: "POST",
        url: "/render_instruction/",
        data: {instruction: is}
    }).done(function(dd,jj,xx) {
        document.getElementById(outputElement).innerHTML = dd;
    });   
}