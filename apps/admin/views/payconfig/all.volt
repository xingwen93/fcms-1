<!doctype html>
<html>
    <head>
        <link rel="stylesheet" href="/css/admin/base.css">
        <link rel="stylesheet" href="/bootstrap/3.3.0/css/bootstrap.min.css">
        <style>
            td {
                vertical-align:middle !important;
            }
            .operate:hover {
                color:green;
            }
        </style>
    </head>
    <body class="wrap">
        <ul class="nav nav-tabs" role="tablist">
            <li role="presentation" class=""><a href="/admin/payconfig/index">使用的支付</a></li>
            <li role="presentation" class="active"><a href="/admin/payconfig/all">所有的支付</a></li>
        </ul>
        <div class="tab-content" style="padding:10px 0px;">
            <div role="tabpannel" class="tab-pane active" id="payList">
                {% if page.items is defined and page.items is not empty %}
                <table class="table table-hover ">
                    <thead>
                        <tr>
                            <th>支付方式</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        {% for item in page.items %}
                        <tr data-id="{{ item.id | escape_attr }}">
                            <td>{{ item.name | e }}
                                <img style="height:30px;" src="{{ item.logo}}">
                            </td>
                            <td>
                                <a href="{{ url( 'admin/payconfig/add?id=' ) }}{{ item.id | escape_attr  }}"><i class="glyphicon glyphicon-plus operate" ></i></a>
                            </td>
                        </tr>
                        {% endfor %}
                    </tbody>
                </table>
                {% else %}
                <div class="col-xs-12 text-center">无优惠券 </div>
                {% endif %}
                {% if page.total_pages > 1 %}
                <nav class="text-right" >
                    <ul class="pagination pagination-sm" style="margin-top:0"> 
                        <li class="{% if page.current == 1 %}disabled{% endif %}"><a href="{{ url( 'admin/payconfig/index?page=' ) }}{{page.before}}" >&laquo;</a></li>
                        {% if  1 != page.current and 1 != page.before %}
                        <li><a href="{{ url( 'admin/payconfig/index') }}">1</a></li>
                        {% endif %}
                        {% if page.before != page.current  %}
                        <li><a href="{{ url( 'admin/payconfig/index?page=') }}{{ page.before }}"><span >{{ page.before }}</span></a></li>
                        {% endif %}
                        <li class="active"><a href="{{ url( 'admin/payconfig/index?page=') }}{{ page.current }}"><span >{{ page.current }}</span></a></li>
                        {% if page.next != page.current %}
                        <li><a href="{{ url( 'admin/payconfig/index?page=') }}{{ page.next }}">{{ page.next }}</a></li>
                        {% endif %}
                        {% if page.next  < page.last - 1 %}
                        <li><a>...</a></li>
                        {% endif %}
                        {% if page.last != page.next %}
                        <li><a href="{{ url( 'admin/payconfig/index?page=') }}{{ page.last }}">{{ page.last }}</a></li>
                        {% endif %}
                        <li class="{% if page.current == page.last %}disabled{% endif %}"><a href="{{ url( 'admin/payconfig/index?page=' ) }}{{page.next}}" >&raquo;</a></li>

                    </ul>
                </nav>
                {% endif %}
            </div>
        </div>
        <div class="alert alert-danger text-center col-xs-2" style="display:none;margin-left: 40%;">
            <span>删除失败</span>
        </div>
        <script src="/js/jquery/jquery-1.11.1.min.js"></script>
        <script>
        var key = "<?php echo $this->security->getTokenKey();?>";
     	var token = "<?php echo $this->security->getToken();?>";
    $( function(){
       /*----------------点击表格行---------------*/
       $( 'table' ).delegate( 'tr', 'click', function( e ){
            var tag = e.target.tagName;
            if(  tag === 'TD' ) 
                location = '/admin/payconfig/read?id=' + $( this ).attr( 'data-id' );
       });
       /*----------------删除-----------------*/
       $( 'table' ).delegate( '.couponDelete', 'click', function(){
            var isDel = confirm( '是否删除该支付方式' );
            if( isDel )
            {
                var id = $( this ).attr( 'data-id' );
                var data = {'id': id, 'key':key, 'token':token};
                var _this = this;

                $.post( '/admin/payconfig/delete', data, function( ret ){
                    if( !ret.status )
                        $( _this ).parents( 'tr' ).remove();
                    else
                       errorMsg( ret.msg );
                    
                    key = ret.key;
                    token = ret.token;
                }, 'json').error(function(){ //网络不通
                    errorMsg( '网络不通' );
                });
            }
            return false;
       });
    });
    function  errorMsg( msg )
    {
       $( '.alert span' ).text( msg );
       $( '.alert' ).removeClass( 'alert-success' ).addClass( 'alert-danger' );
       $( '.alert' ).show().fadeOut( 3000 );
    }
        </script>
    </body>
</html>