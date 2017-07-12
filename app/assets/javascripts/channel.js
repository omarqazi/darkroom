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
        console.log(data,jq,xhr);
    }).fail(function(data,jq,xhr) {
        console.log(data,jq,xhr);
    }); 
}