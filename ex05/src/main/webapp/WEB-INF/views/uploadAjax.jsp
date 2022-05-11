<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
    .uploadResult{
        width: 100%;
        background-color: gray;
    }
    .uploadResult ul{
        display: flex;
        flex-flow: row;
        justify-content: center;
        align-items: center;
    }
    .uploadResult ul li{
        list-style: none;
        padding: 10px;
        align-content: center;
        text-align: center;
    }
    .uploadResult ul li img{
        width: 100px;
    }
    .uploadResult ul li span {
        color: white;
    }
    .bigPictureWrapper{
        position: absolute;
        display: none;
        justify-content: center;
        align-items: center;
        top: 0%;
        width: 100%;
        height: 100%;
        background-color: gray;
        z-index: 100;
        background: rgba(255, 255, 255, 0.5);
    }
    .bigPicture{
        position: relative;
        display: flex;
        justify-content: center;
        align-items: center;
    }
</style>
</head>
<body>
    <h1>Upload with Ajax</h1>

    <div class="uploadDiv">
        <input type="file" name="uploadFile" multiple>
    </div>
    <button id="uploadBtn">Upload</button>

    <div class="uploadResult">
        <ul>

        </ul>
    </div>

    <div class="bigPictureWrapper">
        <div class="bigPicture">

        </div>
    </div>


    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

    <script>
        // 원본 이미지 보여주기
        function showImage(fileCallPath){

            // alert(fileCallPath);

            $(".bigPictureWrapper").css("display", "flex").show();

            $(".bigPicture").html("<img src='/display?fileName=" + encodeURI(fileCallPath) + "'>")
                            .animate({width: '100%', height: '100%'}, 1000);
        }

        // 원본 이미지 닫기
        $(".bigPictureWrapper").on("click", function(e){
            $(".bigPicture").animate({width: '0%', height: '0%'}, 1000);
            setTimeout(() => {
                $(this).hide();
            }, 1000);
            /* IE 11 에서 동작하려면. '=>(ES6 화살표 함수)' 사용 불가
            setTimeout(function(){
                $('.bigPictureWrapper').hide();
            }, 1000);
            */
        });

        // x 표시 눌러 파일 삭제하기 (동적 요소 이벤트 위임 방식)
        $(".uploadResult").on("click", "span", function(){

            var targetFile = $(this).data("file");
            var type = $(this).data("type");
            console.log(targetFile);

            $.ajax({
                url : '/deleteFile',
                data : {
                    fileName : targetFile,
                    type : type
                },
                dataType : 'text',
                type : 'POST',
                success : function(result){
                    alert(result);
                }
            });
        });

        $(document).ready(function(){

            // 파일 확장자와 크기 설정
            var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
            var maxSize = 5242880;  // 5MB

            function checkExtension(fileName, fileSize){

                if(fileSize >= maxSize) {
                    alert("파일 사이즈 초과");
                    return false;
                }

                if(regex.test(fileName)){
                    alert("해당 종류의 파일은 업로드할 수 없습니다.");
                    return false;
                }
                return true;
            }

            var cloneObj = $(".uploadDiv").clone();

            $("#uploadBtn").on("click", function(e){

                // jqeury를 이용하는 경우 파일 업로드는 FormData 객체 이용 (가상의 <form>태그와 같음)
                var formData = new FormData();

                var inputFile = $("input[name='uploadFile']");

                var files = inputFile[0].files;

                console.log(files);

                // add File Data to formData
                for(var i=0; i<files.length; i++) {

                    if(!checkExtension(files[i].name, files[i].size) ){
                        return false;
                    }

                    formData.append("uploadFile", files[i]);
                }

                // 업로드 결과 ul에 추가
                var uploadResult = $(".uploadResult ul");

                function showUploadedFile(uploadResultArr) {

                    var str = "";

                    $(uploadResultArr).each(function(i, obj) {

                        if(!obj.image) {

                            var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);

                            var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");

                            str += "<li><div><a href='/download?fileName="+fileCallPath+"'>"
                                + "<img src='/resources/img/bono.jpg'>" + obj.fileName + "</a>"
                                + "<span data-file=\'" + fileCallPath + "\' data-type='file'> x </span></div></li>";
                        }
                        else{
                            // str += "<li>" + obj.fileName + "</li>";
                            var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);

                            var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;

                            originPath = originPath.replace(new RegExp(/\\/g), "/");

                            str += "<li><a href=\"javascript:showImage(\'" + originPath + "\')\">"
                                + "<img src='/display?fileName=" + fileCallPath + "'></a>"
                                + "<span data-file=\'" + fileCallPath + "\' data-type='image'> x </span></li>";
                        }
                    });

                    uploadResult.append(str);
                }

                $.ajax({
                    url : '/uploadAjaxAction',
                    // processData, contentType 반드시 false로 지정.
                    processData : false,
                    contentType : false,
                    data : formData,
                    type : 'POST',
                    dataType : 'json',
                    success : function(result) {

                        console.log(result);

                        showUploadedFile(result);

                        $(".uploadDiv").html(cloneObj.html());
                    }
                });
            });
        });
    </script>
</body>
</html>