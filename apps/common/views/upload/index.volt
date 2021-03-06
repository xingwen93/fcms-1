
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1"><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><title>
	UEditor演示
</title>
    <script src="/js/jquery/jquery-1.10.2.min.js"></script>
    <script src="/u/ueditor.config.js"></script>
    <script src="/u/ueditor.all.js"></script>
    <style type="text/css">
        a { color: #444; text-decoration: none; margin: 0; padding: 0; }
        dl { width: 800px; margin: 10px auto; float: left; font-size: 12px; }
            dl dt { width: 340px; float: left; }
                dl dt input { width: 300px; }
            dl dd { width: 130px; float: left; margin: 0; }
                dl dd a { display: inline-block; width: 72px; height: 28px; text-align: center; line-height: 28px; border: #ddd; }
                dl dd img { width: 90px; height: 60px; }
        .editor { width: 800px; height: 300px; float: left; }
    </style>
</head>
<body>

    <div>
        <dl>
            <dt><span>图片：</span><input type="text" id="picture" name="cover" /></dt>
            <dd><a href="javascript:void(0);" onclick="upImage();">上传图片</a></dd>
            <dd>
                <img id="preview" src="" /></dd>
        </dl>
        <dl>
            <dt><span>文件：</span><input type="text" id="file" /></dt>
            <dd><a href="javascript:void(0);" onclick="upFiles();">上传文件</a></dd>
        </dl>
        <div class="editor">
            <script type="text/plain" id="myEditor"></script>
            <script type="text/plain" id="upload_ue"></script>
        </div>
    </div>

    <script type="text/javascript">
        //编辑器
        var editor = UE.getEditor('myEditor', {
            initialFrameWidth: 800,
            initialFrameHeight: 400,
            minFrameHeight: 400,
            initialStyle: 'body{font-size:12px}',
            topOffset: 200,
            sid: '{{ session.getId()}}',
        	bizt:'user',
        	serverUrl:'/common/upload/ctrl.php'
        });
        
         editor.ready( function(){
            this.options.imageMaxSize = 10000000;//单位是byte;控制图片大小的
//            this.options.imageAllowFiles =  [ '.jpg'];
            this.execCommand('serverparam', {
                width: 10000,//图片的宽度
                height:10000 //图片的高度
            });
        });
        //上传独立使用
        var _editor = UE.getEditor('upload_ue',{ sid: '{{ session.getId() }}',
            	bizt:'mem', serverUrl:'http://admin.huaer.dev/common/upload/ctrl.php' } );

        _editor.ready(function () {
            this.options.imageMaxSize = 1000;
            _editor.hide();
            _editor.addListener('beforeinsertimage', function (t, arg) {     //侦听图片上传
                alert(111);
                console.log(  arg );
                $("#picture").attr("value", arg[0].src);                      //将地址赋值给相应的input
                $("#preview").attr("src", arg[0].src);
                return true;
            });

            _editor.addListener( 'afterinsertimage', function( t, arg ){
                alert(111);

                });

            _editor.addListener('afterUpfile', function (t, arg) {
//            	toastr.error( 'afterUpfile' );
                $("#file").attr("value", _editor.options.UEDITOR_HOME_URL + arg[0].url);
            });

//            _editor.setDisabled( [ 'insertimage', 'attachment' ]);
            
        });
        function upImage() {
            var myImage = _editor.getDialog("insertimage");
            myImage.open();
            
        }
        function upFiles() {
            var myFiles = _editor.getDialog("attachment");
            myFiles.open();
        }
    </script>
</body>
</html>