-- ----------------------------
-- 1、部门表
-- ----------------------------
drop table if exists sys_dept;
create table sys_dept (
  dept_id           bigint(20)      not null auto_increment    comment '部门id',
  parent_id         bigint(20)      default 0                  comment '父部门id',
  ancestors         varchar(50)     default ''                 comment '祖级列表',
  dept_name         varchar(30)     default ''                 comment '部门名称',
  order_num         int(4)          default 0                  comment '显示顺序',
  leader            varchar(20)     default null               comment '负责人',
  phone             varchar(11)     default null               comment '联系电话',
  email             varchar(50)     default null               comment '邮箱',
  status            char(1)         default '0'                comment '部门状态（0正常 1停用）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 	    datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  primary key (dept_id)
) engine=innodb auto_increment=200 comment = '部门表';

-- ----------------------------
-- 初始化-部门表数据
-- ----------------------------

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.



-- ----------------------------
-- 2、用户信息表
-- ----------------------------
drop table if exists sys_user;
create table sys_user (
  user_id           bigint(20)      not null auto_increment    comment '用户ID',
  dept_id           bigint(20)      default null               comment '部门ID',
  user_name         varchar(30)     not null                   comment '用户账号',
  nick_name         varchar(30)     not null                   comment '用户昵称',
  user_type         varchar(2)      default '00'               comment '用户类型（00系统用户）',
  email             varchar(50)     default ''                 comment '用户邮箱',
  phonenumber       varchar(11)     default ''                 comment '手机号码',
  sex               char(1)         default '0'                comment '用户性别（0男 1女 2未知）',
  avatar            varchar(100)    default ''                 comment '头像地址',
  password          varchar(100)    default ''                 comment '密码',
  status            char(1)         default '0'                comment '账号状态（0正常 1停用）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  login_ip          varchar(128)    default ''                 comment '最后登录IP',
  login_date        datetime                                   comment '最后登录时间',
  pwd_update_date   datetime                                   comment '密码最后更新时间',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (user_id)
) engine=innodb auto_increment=100 comment = '用户信息表';

-- ----------------------------
-- 初始化-用户信息表数据
-- ----------------------------

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.



-- ----------------------------
-- 3、岗位信息表
-- ----------------------------
drop table if exists sys_post;
create table sys_post
(
  post_id       bigint(20)      not null auto_increment    comment '岗位ID',
  post_code     varchar(64)     not null                   comment '岗位编码',
  post_name     varchar(50)     not null                   comment '岗位名称',
  post_sort     int(4)          not null                   comment '显示顺序',
  status        char(1)         not null                   comment '状态（0正常 1停用）',
  create_by     varchar(64)     default ''                 comment '创建者',
  create_time   datetime                                   comment '创建时间',
  update_by     varchar(64)     default ''			       comment '更新者',
  update_time   datetime                                   comment '更新时间',
  remark        varchar(500)    default null               comment '备注',
  primary key (post_id)
) engine=innodb comment = '岗位信息表';

-- ----------------------------
-- 初始化-岗位信息表数据
-- ----------------------------

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.



-- ----------------------------
-- 4、角色信息表
-- ----------------------------
drop table if exists sys_role;
create table sys_role (
  role_id              bigint(20)      not null auto_increment    comment '角色ID',
  role_name            varchar(30)     not null                   comment '角色名称',
  role_key             varchar(100)    not null                   comment '角色权限字符串',
  role_sort            int(4)          not null                   comment '显示顺序',
  data_scope           char(1)         default '1'                comment '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  menu_check_strictly  tinyint(1)      default 1                  comment '菜单树选择项是否关联显示',
  dept_check_strictly  tinyint(1)      default 1                  comment '部门树选择项是否关联显示',
  status               char(1)         not null                   comment '角色状态（0正常 1停用）',
  del_flag             char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by            varchar(64)     default ''                 comment '创建者',
  create_time          datetime                                   comment '创建时间',
  update_by            varchar(64)     default ''                 comment '更新者',
  update_time          datetime                                   comment '更新时间',
  remark               varchar(500)    default null               comment '备注',
  primary key (role_id)
) engine=innodb auto_increment=100 comment = '角色信息表';

-- ----------------------------
-- 初始化-角色信息表数据
-- ----------------------------

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.



-- ----------------------------
-- 5、菜单权限表
-- ----------------------------
drop table if exists sys_menu;
create table sys_menu (
  menu_id           bigint(20)      not null auto_increment    comment '菜单ID',
  menu_name         varchar(50)     not null                   comment '菜单名称',
  parent_id         bigint(20)      default 0                  comment '父菜单ID',
  order_num         int(4)          default 0                  comment '显示顺序',
  path              varchar(200)    default ''                 comment '路由地址',
  component         varchar(255)    default null               comment '组件路径',
  query             varchar(255)    default null               comment '路由参数',
  route_name        varchar(50)     default ''                 comment '路由名称',
  is_frame          int(1)          default 1                  comment '是否为外链（0是 1否）',
  is_cache          int(1)          default 0                  comment '是否缓存（0缓存 1不缓存）',
  menu_type         char(1)         default ''                 comment '菜单类型（M目录 C菜单 F按钮）',
  visible           char(1)         default 0                  comment '菜单状态（0显示 1隐藏）',
  status            char(1)         default 0                  comment '菜单状态（0正常 1停用）',
  perms             varchar(100)    default null               comment '权限标识',
  icon              varchar(100)    default '#'                comment '菜单图标',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default ''                 comment '备注',
  primary key (menu_id)
) engine=innodb auto_increment=2000 comment = '菜单权限表';

-- ----------------------------
-- 初始化-菜单信息表数据
-- ----------------------------
-- 一级菜单

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.

# insert into sys_menu values('3', '系统工具', '0', '3', 'tool',             null, '', '', 1, 0, 'M', '0', '0', '', 'tool',     'admin', sysdate(), '', null, '系统工具目录');
-- 二级菜单

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.

# insert into sys_menu values('103',  '部门管理', '1',   '4', 'dept',       'system/dept/index',        '', '', 1, 0, 'C', '0', '0', 'system:dept:list',        'tree',          'admin', sysdate(), '', null, '部门管理菜单');
# insert into sys_menu values('104',  '岗位管理', '1',   '5', 'post',       'system/post/index',        '', '', 1, 0, 'C', '0', '0', 'system:post:list',        'post',          'admin', sysdate(), '', null, '岗位管理菜单');

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.

# insert into sys_menu values('115',  '表单构建', '3',   '1', 'build',      'tool/build/index',         '', '', 1, 0, 'C', '0', '0', 'tool:build:list',         'build',         'admin', sysdate(), '', null, '表单构建菜单');
# insert into sys_menu values('116',  '代码生成', '3',   '2', 'gen',        'tool/gen/index',           '', '', 1, 0, 'C', '0', '0', 'tool:gen:list',           'code',          'admin', sysdate(), '', null, '代码生成菜单');

-- Data rows omitted from the public source snapshot.

-- 三级菜单

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.

-- 用户管理按钮

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.

-- 角色管理按钮

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.

-- 菜单管理按钮

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.

# -- 部门管理按钮
# insert into sys_menu values('1016', '部门查询', '103', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query',          '#', 'admin', sysdate(), '', null, '');
# insert into sys_menu values('1017', '部门新增', '103', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add',            '#', 'admin', sysdate(), '', null, '');
# insert into sys_menu values('1018', '部门修改', '103', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit',           '#', 'admin', sysdate(), '', null, '');
# insert into sys_menu values('1019', '部门删除', '103', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove',         '#', 'admin', sysdate(), '', null, '');
# -- 岗位管理按钮
# insert into sys_menu values('1020', '岗位查询', '104', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query',          '#', 'admin', sysdate(), '', null, '');
# insert into sys_menu values('1021', '岗位新增', '104', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add',            '#', 'admin', sysdate(), '', null, '');
# insert into sys_menu values('1022', '岗位修改', '104', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit',           '#', 'admin', sysdate(), '', null, '');
# insert into sys_menu values('1023', '岗位删除', '104', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove',         '#', 'admin', sysdate(), '', null, '');
# insert into sys_menu values('1024', '岗位导出', '104', '5',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export',         '#', 'admin', sysdate(), '', null, '');
-- 字典管理按钮

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.

-- 参数设置按钮

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.

-- 通知公告按钮

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.

-- 操作日志按钮

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.

-- 登录日志按钮

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.

-- 在线用户按钮

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.

-- 定时任务按钮

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.

-- 代码生成按钮
# insert into sys_menu values('1055', '生成查询', '116', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query',             '#', 'admin', sysdate(), '', null, '');
# insert into sys_menu values('1056', '生成修改', '116', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit',              '#', 'admin', sysdate(), '', null, '');
# insert into sys_menu values('1057', '生成删除', '116', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove',            '#', 'admin', sysdate(), '', null, '');
# insert into sys_menu values('1058', '导入代码', '116', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import',            '#', 'admin', sysdate(), '', null, '');
# insert into sys_menu values('1059', '预览代码', '116', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview',           '#', 'admin', sysdate(), '', null, '');
# insert into sys_menu values('1060', '生成代码', '116', '6', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code',              '#', 'admin', sysdate(), '', null, '');


-- ----------------------------
-- 6、用户和角色关联表  用户N-1角色
-- ----------------------------
drop table if exists sys_user_role;
create table sys_user_role (
  user_id   bigint(20) not null comment '用户ID',
  role_id   bigint(20) not null comment '角色ID',
  primary key(user_id, role_id)
) engine=innodb comment = '用户和角色关联表';

-- ----------------------------
-- 初始化-用户和角色关联表数据
-- ----------------------------

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.



-- ----------------------------
-- 7、角色和菜单关联表  角色1-N菜单
-- ----------------------------
drop table if exists sys_role_menu;
create table sys_role_menu (
  role_id   bigint(20) not null comment '角色ID',
  menu_id   bigint(20) not null comment '菜单ID',
  primary key(role_id, menu_id)
) engine=innodb comment = '角色和菜单关联表';

-- ----------------------------
-- 初始化-角色和菜单关联表数据
-- ----------------------------

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- ----------------------------
-- 8、角色和部门关联表  角色1-N部门
-- ----------------------------
drop table if exists sys_role_dept;
create table sys_role_dept (
  role_id   bigint(20) not null comment '角色ID',
  dept_id   bigint(20) not null comment '部门ID',
  primary key(role_id, dept_id)
) engine=innodb comment = '角色和部门关联表';

-- ----------------------------
-- 初始化-角色和部门关联表数据
-- ----------------------------

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.



-- ----------------------------
-- 9、用户与岗位关联表  用户1-N岗位
-- ----------------------------
drop table if exists sys_user_post;
create table sys_user_post
(
  user_id   bigint(20) not null comment '用户ID',
  post_id   bigint(20) not null comment '岗位ID',
  primary key (user_id, post_id)
) engine=innodb comment = '用户与岗位关联表';

-- ----------------------------
-- 初始化-用户与岗位关联表数据
-- ----------------------------

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.



-- ----------------------------
-- 10、操作日志记录
-- ----------------------------
drop table if exists sys_oper_log;
create table sys_oper_log (
  oper_id           bigint(20)      not null auto_increment    comment '日志主键',
  title             varchar(50)     default ''                 comment '模块标题',
  business_type     int(2)          default 0                  comment '业务类型（0其它 1新增 2修改 3删除）',
  method            varchar(200)    default ''                 comment '方法名称',
  request_method    varchar(10)     default ''                 comment '请求方式',
  operator_type     int(1)          default 0                  comment '操作类别（0其它 1后台用户 2手机端用户）',
  oper_name         varchar(50)     default ''                 comment '操作人员',
  dept_name         varchar(50)     default ''                 comment '部门名称',
  oper_url          varchar(255)    default ''                 comment '请求URL',
  oper_ip           varchar(128)    default ''                 comment '主机地址',
  oper_location     varchar(255)    default ''                 comment '操作地点',
  oper_param        varchar(2000)   default ''                 comment '请求参数',
  json_result       varchar(2000)   default ''                 comment '返回参数',
  status            int(1)          default 0                  comment '操作状态（0正常 1异常）',
  error_msg         varchar(2000)   default ''                 comment '错误消息',
  oper_time         datetime                                   comment '操作时间',
  cost_time         bigint(20)      default 0                  comment '消耗时间',
  primary key (oper_id),
  key idx_sys_oper_log_bt (business_type),
  key idx_sys_oper_log_s  (status),
  key idx_sys_oper_log_ot (oper_time)
) engine=innodb auto_increment=100 comment = '操作日志记录';


-- ----------------------------
-- 11、字典类型表
-- ----------------------------
drop table if exists sys_dict_type;
create table sys_dict_type
(
  dict_id          bigint(20)      not null auto_increment    comment '字典主键',
  dict_name        varchar(100)    default ''                 comment '字典名称',
  dict_type        varchar(100)    default ''                 comment '字典类型',
  status           char(1)         default '0'                comment '状态（0正常 1停用）',
  create_by        varchar(64)     default ''                 comment '创建者',
  create_time      datetime                                   comment '创建时间',
  update_by        varchar(64)     default ''                 comment '更新者',
  update_time      datetime                                   comment '更新时间',
  remark           varchar(500)    default null               comment '备注',
  primary key (dict_id),
  unique (dict_type)
) engine=innodb auto_increment=100 comment = '字典类型表';

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.



-- ----------------------------
-- 12、字典数据表
-- ----------------------------
drop table if exists sys_dict_data;
create table sys_dict_data
(
  dict_code        bigint(20)      not null auto_increment    comment '字典编码',
  dict_sort        int(4)          default 0                  comment '字典排序',
  dict_label       varchar(100)    default ''                 comment '字典标签',
  dict_value       varchar(100)    default ''                 comment '字典键值',
  dict_type        varchar(100)    default ''                 comment '字典类型',
  css_class        varchar(100)    default null               comment '样式属性（其他样式扩展）',
  list_class       varchar(100)    default null               comment '表格回显样式',
  is_default       char(1)         default 'N'                comment '是否默认（Y是 N否）',
  status           char(1)         default '0'                comment '状态（0正常 1停用）',
  create_by        varchar(64)     default ''                 comment '创建者',
  create_time      datetime                                   comment '创建时间',
  update_by        varchar(64)     default ''                 comment '更新者',
  update_time      datetime                                   comment '更新时间',
  remark           varchar(500)    default null               comment '备注',
  primary key (dict_code)
) engine=innodb auto_increment=100 comment = '字典数据表';

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.



-- ----------------------------
-- 13、参数配置表
-- ----------------------------
drop table if exists sys_config;
create table sys_config (
  config_id         int(5)          not null auto_increment    comment '参数主键',
  config_name       varchar(100)    default ''                 comment '参数名称',
  config_key        varchar(100)    default ''                 comment '参数键名',
  config_value      varchar(500)    default ''                 comment '参数键值',
  config_type       char(1)         default 'N'                comment '系统内置（Y是 N否）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (config_id)
) engine=innodb auto_increment=100 comment = '参数配置表';

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.



-- ----------------------------
-- 14、系统访问记录
-- ----------------------------
drop table if exists sys_logininfor;
create table sys_logininfor (
  info_id        bigint(20)     not null auto_increment   comment '访问ID',
  user_name      varchar(50)    default ''                comment '用户账号',
  ipaddr         varchar(128)   default ''                comment '登录IP地址',
  login_location varchar(255)   default ''                comment '登录地点',
  browser        varchar(50)    default ''                comment '浏览器类型',
  os             varchar(50)    default ''                comment '操作系统',
  status         char(1)        default '0'               comment '登录状态（0成功 1失败）',
  msg            varchar(255)   default ''                comment '提示消息',
  login_time     datetime                                 comment '访问时间',
  primary key (info_id),
  key idx_sys_logininfor_s  (status),
  key idx_sys_logininfor_lt (login_time)
) engine=innodb auto_increment=100 comment = '系统访问记录';


-- ----------------------------
-- 15、定时任务调度表
-- ----------------------------
drop table if exists sys_job;
create table sys_job (
  job_id              bigint(20)    not null auto_increment    comment '任务ID',
  job_name            varchar(64)   default ''                 comment '任务名称',
  job_group           varchar(64)   default 'DEFAULT'          comment '任务组名',
  invoke_target       varchar(500)  not null                   comment '调用目标字符串',
  cron_expression     varchar(255)  default ''                 comment 'cron执行表达式',
  misfire_policy      varchar(20)   default '3'                comment '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  concurrent          char(1)       default '1'                comment '是否并发执行（0允许 1禁止）',
  status              char(1)       default '0'                comment '状态（0正常 1暂停）',
  create_by           varchar(64)   default ''                 comment '创建者',
  create_time         datetime                                 comment '创建时间',
  update_by           varchar(64)   default ''                 comment '更新者',
  update_time         datetime                                 comment '更新时间',
  remark              varchar(500)  default ''                 comment '备注信息',
  primary key (job_id, job_name, job_group)
) engine=innodb auto_increment=100 comment = '定时任务调度表';

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.



-- ----------------------------
-- 16、定时任务调度日志表
-- ----------------------------
drop table if exists sys_job_log;
create table sys_job_log (
  job_log_id          bigint(20)     not null auto_increment    comment '任务日志ID',
  job_name            varchar(64)    not null                   comment '任务名称',
  job_group           varchar(64)    not null                   comment '任务组名',
  invoke_target       varchar(500)   not null                   comment '调用目标字符串',
  job_message         varchar(500)                              comment '日志信息',
  status              char(1)        default '0'                comment '执行状态（0正常 1失败）',
  exception_info      varchar(2000)  default ''                 comment '异常信息',
  create_time         datetime                                  comment '创建时间',
  primary key (job_log_id)
) engine=innodb comment = '定时任务调度日志表';


-- ----------------------------
-- 17、通知公告表
-- ----------------------------
drop table if exists sys_notice;
create table sys_notice (
  notice_id         int(4)          not null auto_increment    comment '公告ID',
  notice_title      varchar(50)     not null                   comment '公告标题',
  notice_type       char(1)         not null                   comment '公告类型（1通知 2公告）',
  notice_content    longblob        default null               comment '公告内容',
  status            char(1)         default '0'                comment '公告状态（0正常 1关闭）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(255)    default null               comment '备注',
  primary key (notice_id)
) engine=innodb auto_increment=10 comment = '通知公告表';

-- ----------------------------
-- 初始化-公告信息表数据
-- ----------------------------

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.



-- ----------------------------
-- 18、代码生成业务表
-- ----------------------------
drop table if exists gen_table;
create table gen_table (
  table_id          bigint(20)      not null auto_increment    comment '编号',
  table_name        varchar(200)    default ''                 comment '表名称',
  table_comment     varchar(500)    default ''                 comment '表描述',
  sub_table_name    varchar(64)     default null               comment '关联子表的表名',
  sub_table_fk_name varchar(64)     default null               comment '子表关联的外键名',
  class_name        varchar(100)    default ''                 comment '实体类名称',
  tpl_category      varchar(200)    default 'crud'             comment '使用的模板（crud单表操作 tree树表操作）',
  tpl_web_type      varchar(30)     default ''                 comment '前端模板类型（element-ui模版 element-plus模版）',
  package_name      varchar(100)                               comment '生成包路径',
  module_name       varchar(30)                                comment '生成模块名',
  business_name     varchar(30)                                comment '生成业务名',
  function_name     varchar(50)                                comment '生成功能名',
  function_author   varchar(50)                                comment '生成功能作者',
  gen_type          char(1)         default '0'                comment '生成代码方式（0zip压缩包 1自定义路径）',
  gen_path          varchar(200)    default '/'                comment '生成路径（不填默认项目路径）',
  options           varchar(1000)                              comment '其它生成选项',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 	    datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (table_id)
) engine=innodb auto_increment=1 comment = '代码生成业务表';


-- ----------------------------
-- 19、代码生成业务表字段
-- ----------------------------
drop table if exists gen_table_column;
create table gen_table_column (
  column_id         bigint(20)      not null auto_increment    comment '编号',
  table_id          bigint(20)                                 comment '归属表编号',
  column_name       varchar(200)                               comment '列名称',
  column_comment    varchar(500)                               comment '列描述',
  column_type       varchar(100)                               comment '列类型',
  java_type         varchar(500)                               comment 'JAVA类型',
  java_field        varchar(200)                               comment 'JAVA字段名',
  is_pk             char(1)                                    comment '是否主键（1是）',
  is_increment      char(1)                                    comment '是否自增（1是）',
  is_required       char(1)                                    comment '是否必填（1是）',
  is_insert         char(1)                                    comment '是否为插入字段（1是）',
  is_edit           char(1)                                    comment '是否编辑字段（1是）',
  is_list           char(1)                                    comment '是否列表字段（1是）',
  is_query          char(1)                                    comment '是否查询字段（1是）',
  query_type        varchar(200)    default 'EQ'               comment '查询方式（等于、不等于、大于、小于、范围）',
  html_type         varchar(200)                               comment '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  dict_type         varchar(200)    default ''                 comment '字典类型',
  sort              int                                        comment '排序',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 	    datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  primary key (column_id)
) engine=innodb auto_increment=1 comment = '代码生成业务表字段';

-- 街道待就业人员管理服务系统 - 就业服务子系统扩展
-- 创建日期: 2026-02-16
-- 说明: 本文件为增量脚本，不修改 sql/table.sql

-- 1) 业务表

drop table if exists emp_user_profile;
create table emp_user_profile (
                                  profile_id         bigint(20)      not null auto_increment comment '档案ID',
                                  user_id            bigint(20)      not null                comment '系统用户ID(sys_user.user_id)',
                                  real_name          varchar(50)     default ''              comment '真实姓名',
                                  gender             char(1)         default '2'             comment '性别(0男 1女 2未知)',
                                  age                int(11)         default null            comment '年龄',
                                  phone              varchar(20)     default ''              comment '联系电话',
                                  education          varchar(50)     default ''              comment '学历',
                                  skill_tags         varchar(255)    default ''              comment '技能标签，逗号分隔',
                                  certificate_urls   text                                    comment '技能证书URL，逗号分隔',
                                  employment_status  char(1)         default '0'             comment '就业状态(0待审核 1在库跟踪 2已就业)',
                                  audit_status       char(1)         default '0'             comment '审核状态(0待审核 1通过 2驳回)',
                                  id_card            varchar(18)     default ''              comment '身份证号',
                                  address            varchar(255)    default ''              comment '联系地址',
                                  introduction       varchar(500)    default ''              comment '个人简介',
                                  create_by          varchar(64)     default ''              comment '创建者',
                                  create_time        datetime                                comment '创建时间',
                                  update_by          varchar(64)     default ''              comment '更新者',
                                  update_time        datetime                                comment '更新时间',
                                  remark             varchar(500)    default null            comment '备注',
                                  primary key (profile_id),
                                  unique key uk_emp_profile_user (user_id)
) engine=innodb comment='待就业人员档案表';

drop table if exists emp_service_category;
create table emp_service_category (
                                      category_id        bigint(20)      not null auto_increment comment '分类ID',
                                      category_type      char(1)         not null                comment '分类类型(1岗位 2培训 3政策)',
                                      category_code      varchar(50)     not null                comment '分类编码',
                                      category_name      varchar(100)    not null                comment '分类名称',
                                      sort_order         int(11)         default 0               comment '显示顺序',
                                      status             char(1)         default '0'             comment '状态(0正常 1停用)',
                                      create_by          varchar(64)     default ''              comment '创建者',
                                      create_time        datetime                                comment '创建时间',
                                      update_by          varchar(64)     default ''              comment '更新者',
                                      update_time        datetime                                comment '更新时间',
                                      remark             varchar(500)    default null            comment '备注',
                                      primary key (category_id),
                                      unique key uk_emp_category_code (category_code)
) engine=innodb comment='服务分类维护表';

drop table if exists emp_position;
create table emp_position (
                              position_id        bigint(20)      not null auto_increment comment '岗位ID',
                              position_name      varchar(100)    not null                comment '岗位名称',
                              company_name       varchar(100)    not null                comment '企业名称',
                              category_code      varchar(50)     default ''              comment '岗位分类编码',
                              salary_range       varchar(50)     default ''              comment '薪资范围',
                              work_address       varchar(255)    default ''              comment '工作地点',
                              contact_name       varchar(30)     default ''              comment '联系人',
                              contact_phone      varchar(20)     default ''              comment '联系电话',
                              requirement_text   varchar(1000)   default ''              comment '岗位要求',
                              audit_status       char(1)         default '0'             comment '审核状态(0待审核 1通过 2驳回)',
                              publish_status     char(1)         default '0'             comment '发布状态(0上架 1下架)',
                              publish_time       datetime                                comment '发布时间',
                              create_by          varchar(64)     default ''              comment '创建者',
                              create_time        datetime                                comment '创建时间',
                              update_by          varchar(64)     default ''              comment '更新者',
                              update_time        datetime                                comment '更新时间',
                              remark             varchar(500)    default null            comment '备注',
                              primary key (position_id)
) engine=innodb comment='招聘岗位表';

drop table if exists emp_position_apply;
create table emp_position_apply (
                                    apply_id           bigint(20)      not null auto_increment comment '申请ID',
                                    position_id        bigint(20)      not null                comment '岗位ID',
                                    user_id            bigint(20)      not null                comment '用户ID',
                                    resume_note        varchar(500)    default ''              comment '补充说明',
                                    apply_status       char(1)         default '0'             comment '申请状态(0已投递 1面试中 2已录用 3未通过)',
                                    apply_time         datetime        default current_timestamp comment '申请时间',
                                    audit_remark       varchar(500)    default ''              comment '审核备注',
                                    create_by          varchar(64)     default ''              comment '创建者',
                                    create_time        datetime                                comment '创建时间',
                                    update_by          varchar(64)     default ''              comment '更新者',
                                    update_time        datetime                                comment '更新时间',
                                    remark             varchar(500)    default null            comment '备注',
                                    primary key (apply_id),
                                    unique key uk_emp_apply_user_position (user_id, position_id)
) engine=innodb comment='岗位申请表';

drop table if exists emp_training;
create table emp_training (
                              training_id        bigint(20)      not null auto_increment comment '培训ID',
                              title              varchar(120)    not null                comment '培训主题',
                              category_code      varchar(50)     default ''              comment '培训分类编码',
                              teacher_name       varchar(50)     default ''              comment '讲师名称',
                              location           varchar(255)    default ''              comment '培训地点',
                              start_time         datetime                                comment '开始时间',
                              end_time           datetime                                comment '结束时间',
                              quota              int(11)         default 30              comment '名额上限',
                              signup_count       int(11)         default 0               comment '已报名人数',
                              status             char(1)         default '0'             comment '状态(0可报名 1已结束)',
                              audit_status       char(1)         default '0'             comment '审核状态(0待审核 1通过 2驳回)',
                              introduction       varchar(1000)   default ''              comment '培训简介',
                              create_by          varchar(64)     default ''              comment '创建者',
                              create_time        datetime                                comment '创建时间',
                              update_by          varchar(64)     default ''              comment '更新者',
                              update_time        datetime                                comment '更新时间',
                              remark             varchar(500)    default null            comment '备注',
                              primary key (training_id)
) engine=innodb comment='培训计划表';

drop table if exists emp_training_record;
create table emp_training_record (
                                     record_id          bigint(20)      not null auto_increment comment '记录ID',
                                     training_id        bigint(20)      not null                comment '培训ID',
                                     user_id            bigint(20)      not null                comment '用户ID',
                                     record_status      char(1)         default '0'             comment '记录状态(0已报名 1已参加 2已完成)',
                                     signup_time        datetime        default current_timestamp comment '报名时间',
                                     create_by          varchar(64)     default ''              comment '创建者',
                                     create_time        datetime                                comment '创建时间',
                                     update_by          varchar(64)     default ''              comment '更新者',
                                     update_time        datetime                                comment '更新时间',
                                     remark             varchar(500)    default null            comment '备注',
                                     primary key (record_id),
                                     unique key uk_emp_training_user (training_id, user_id)
) engine=innodb comment='培训记录表';

drop table if exists emp_consultation;
create table emp_consultation (
                                  consult_id         bigint(20)      not null auto_increment comment '咨询ID',
                                  user_id            bigint(20)      not null                comment '提问用户ID',
                                  consult_type       varchar(50)     default ''              comment '咨询类型',
                                  question_content   varchar(1000)   not null                comment '咨询问题',
                                  answer_content     varchar(1000)   default ''              comment '回复内容',
                                  answer_by          bigint(20)      default null            comment '回复人ID',
                                  answer_time        datetime                                comment '回复时间',
                                  consult_status     char(1)         default '0'             comment '咨询状态(0待回复 1已回复 2已关闭)',
                                  audit_status       char(1)         default '0'             comment '审核状态(0待审核 1通过 2驳回)',
                                  audit_remark       varchar(500)    default ''              comment '审核备注',
                                  create_by          varchar(64)     default ''              comment '创建者',
                                  create_time        datetime                                comment '创建时间',
                                  update_by          varchar(64)     default ''              comment '更新者',
                                  update_time        datetime                                comment '更新时间',
                                  remark             varchar(500)    default null            comment '备注',
                                  primary key (consult_id)
) engine=innodb comment='互动咨询表';

drop table if exists emp_policy;
create table emp_policy (
                            policy_id          bigint(20)      not null auto_increment comment '政策ID',
                            title              varchar(150)    not null                comment '政策标题',
                            policy_tag         varchar(50)     default ''              comment '政策标签',
                            summary            varchar(500)    default ''              comment '政策摘要',
                            content            text                                    comment '政策正文',
                            source_org         varchar(100)    default ''              comment '发布单位',
                            publish_time       datetime                                comment '发布时间',
                            audit_status       char(1)         default '0'             comment '审核状态(0待审核 1通过 2驳回)',
                            status             char(1)         default '0'             comment '状态(0显示 1隐藏)',
                            create_by          varchar(64)     default ''              comment '创建者',
                            create_time        datetime                                comment '创建时间',
                            update_by          varchar(64)     default ''              comment '更新者',
                            update_time        datetime                                comment '更新时间',
                            remark             varchar(500)    default null            comment '备注',
                            primary key (policy_id)
) engine=innodb comment='政策资讯表';

-- 2) 字典类型与字典数据

delete from sys_dict_data where dict_type in (
                                              'emp_profile_status',
                                              'emp_audit_status',
                                              'emp_apply_status',
                                              'emp_consult_status',
                                              'emp_training_status',
                                              'emp_category_type'
    );
delete from sys_dict_type where dict_type in (
                                              'emp_profile_status',
                                              'emp_audit_status',
                                              'emp_apply_status',
                                              'emp_consult_status',
                                              'emp_training_status',
                                              'emp_category_type'
    );

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- 3) 管理端菜单与权限

delete from sys_role_menu where menu_id between 2100 and 2150;
delete from sys_menu where menu_id between 2100 and 2150;

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- 4) 初始化示例数据

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Employment category-code dictionaries
-- Execute this file once after baseline tables are created.

-- 1) Dict types

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- 2) Dict data: job category code

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- 3) Dict data: training category code

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- 4) Dict data: policy tag code

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Skill-tag dictionary for employment front profile
-- Run once in MySQL

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Education dictionary for employment front profile
-- Run once in MySQL

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- ============================================================
-- 就业子系统联动增强补丁（增量）
-- 日期：2026-02-22
-- 目标：
-- 1）增强用户端/管理端业务联动与流程可追踪
-- 2）补齐当前 Mapper 查询所需索引，提升性能
-- 3）提供失业率/就业成功率/年龄/辖区等报表视图
-- 4）补充咨询类型字典，统一前后端口径
-- ============================================================

SET NAMES utf8mb4;

-- ------------------------------------------------------------
-- A. 通用流程/审计日志表
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS emp_flow_log (
                                            flow_id          BIGINT(20)      NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                                            biz_type         VARCHAR(30)     NOT NULL                COMMENT '业务类型：PROFILE/APPLY/TRAINING/CONSULT/POLICY',
                                            biz_id           BIGINT(20)      NOT NULL                COMMENT '业务ID',
                                            user_id          BIGINT(20)      DEFAULT NULL            COMMENT '关联用户ID',
                                            action_type      VARCHAR(30)     NOT NULL                COMMENT '动作类型：CREATE/UPDATE/AUDIT/REPLY/STATUS_CHANGE',
                                            from_status      VARCHAR(120)    DEFAULT ''              COMMENT '变更前状态',
                                            to_status        VARCHAR(120)    DEFAULT ''              COMMENT '变更后状态',
                                            action_detail    VARCHAR(1000)   DEFAULT ''              COMMENT '动作详情',
                                            operator_id      BIGINT(20)      DEFAULT NULL            COMMENT '操作人用户ID',
                                            operator_name    VARCHAR(64)     DEFAULT ''              COMMENT '操作人用户名',
                                            operate_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
                                            ext_json         VARCHAR(2000)   DEFAULT NULL            COMMENT '扩展JSON',
                                            PRIMARY KEY (flow_id),
                                            KEY idx_emp_flow_biz (biz_type, biz_id),
                                            KEY idx_emp_flow_user (user_id),
                                            KEY idx_emp_flow_time (operate_time)
) ENGINE=InnoDB COMMENT='就业业务流程与审计日志';

CREATE TABLE IF NOT EXISTS emp_password_reset_log (
                                                      reset_id         BIGINT(20)      NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                                                      user_id          BIGINT(20)      DEFAULT NULL            COMMENT '目标用户ID',
                                                      user_name        VARCHAR(64)     DEFAULT ''              COMMENT '目标用户名',
                                                      phone            VARCHAR(20)     DEFAULT ''              COMMENT '校验手机号',
                                                      reset_status     CHAR(1)         DEFAULT '0'             COMMENT '重置结果：0成功 1失败',
                                                      request_ip       VARCHAR(128)    DEFAULT ''              COMMENT '请求IP',
                                                      create_time      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                                      remark           VARCHAR(500)    DEFAULT NULL            COMMENT '备注',
                                                      PRIMARY KEY (reset_id),
                                                      KEY idx_emp_pwd_reset_user (user_id),
                                                      KEY idx_emp_pwd_reset_time (create_time)
) ENGINE=InnoDB COMMENT='密码重置审计日志';

-- ------------------------------------------------------------
-- B. 索引增强（幂等）
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_emp_add_index;
DELIMITER $$
CREATE PROCEDURE sp_emp_add_index(
    IN p_table_name VARCHAR(64),
    IN p_index_name VARCHAR(64),
    IN p_cols VARCHAR(255)
)
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = p_table_name
          AND index_name = p_index_name
    ) THEN
        SET @sql_stmt = CONCAT(
                'ALTER TABLE `', p_table_name,
                '` ADD INDEX `', p_index_name,
                '` (', p_cols, ')'
                        );
        PREPARE stmt FROM @sql_stmt;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END$$
DELIMITER ;

CALL sp_emp_add_index('emp_user_profile', 'idx_emp_profile_audit_emp', 'audit_status, employment_status, update_time');
CALL sp_emp_add_index('emp_user_profile', 'idx_emp_profile_real_name', 'real_name');
CALL sp_emp_add_index('emp_user_profile', 'idx_emp_profile_phone', 'phone');

CALL sp_emp_add_index('emp_service_category', 'idx_emp_category_type_status', 'category_type, status, sort_order');

CALL sp_emp_add_index('emp_position', 'idx_emp_position_front', 'audit_status, publish_status, publish_time');
CALL sp_emp_add_index('emp_position', 'idx_emp_position_category', 'category_code');
CALL sp_emp_add_index('emp_position', 'idx_emp_position_name', 'position_name');

CALL sp_emp_add_index('emp_position_apply', 'idx_emp_apply_status_time', 'apply_status, apply_time');
CALL sp_emp_add_index('emp_position_apply', 'idx_emp_apply_position', 'position_id');
CALL sp_emp_add_index('emp_position_apply', 'idx_emp_apply_user_time', 'user_id, apply_time');

CALL sp_emp_add_index('emp_training', 'idx_emp_training_front', 'audit_status, status, start_time');
CALL sp_emp_add_index('emp_training', 'idx_emp_training_category', 'category_code');
CALL sp_emp_add_index('emp_training', 'idx_emp_training_title', 'title');

CALL sp_emp_add_index('emp_training_record', 'idx_emp_tr_record_status_time', 'record_status, signup_time');
CALL sp_emp_add_index('emp_training_record', 'idx_emp_tr_record_user_time', 'user_id, signup_time');

CALL sp_emp_add_index('emp_consultation', 'idx_emp_consult_status_time', 'consult_status, create_time');
CALL sp_emp_add_index('emp_consultation', 'idx_emp_consult_audit_time', 'audit_status, create_time');
CALL sp_emp_add_index('emp_consultation', 'idx_emp_consult_user_time', 'user_id, create_time');

CALL sp_emp_add_index('emp_policy', 'idx_emp_policy_front', 'audit_status, status, publish_time');
CALL sp_emp_add_index('emp_policy', 'idx_emp_policy_tag', 'policy_tag');
CALL sp_emp_add_index('emp_policy', 'idx_emp_policy_title', 'title');

DROP PROCEDURE IF EXISTS sp_emp_add_index;

-- ------------------------------------------------------------
-- C. 基于触发器的联动与流程日志
-- ------------------------------------------------------------

DROP TRIGGER IF EXISTS trg_emp_profile_ai;
DELIMITER $$
CREATE TRIGGER trg_emp_profile_ai
    AFTER INSERT ON emp_user_profile
    FOR EACH ROW
BEGIN

-- Data rows omitted from the public source snapshot.

END$$
DELIMITER ;

DROP TRIGGER IF EXISTS trg_emp_profile_au;
DELIMITER $$
CREATE TRIGGER trg_emp_profile_au
    AFTER UPDATE ON emp_user_profile
    FOR EACH ROW
BEGIN
    IF NOT (NEW.audit_status <=> OLD.audit_status)
        OR NOT (NEW.employment_status <=> OLD.employment_status) THEN

-- Data rows omitted from the public source snapshot.

    END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS trg_emp_apply_ai;
DELIMITER $$
CREATE TRIGGER trg_emp_apply_ai
    AFTER INSERT ON emp_position_apply
    FOR EACH ROW
BEGIN

-- Data rows omitted from the public source snapshot.

END$$
DELIMITER ;

DROP TRIGGER IF EXISTS trg_emp_apply_au;
DELIMITER $$
CREATE TRIGGER trg_emp_apply_au
    AFTER UPDATE ON emp_position_apply
    FOR EACH ROW
BEGIN
    IF NOT (NEW.apply_status <=> OLD.apply_status) THEN

-- Data rows omitted from the public source snapshot.

    END IF;

    -- 联动闭环：
    -- 当申请状态变为“2（已录用）”时，自动将档案就业状态更新为“2（已就业）”。
    IF NEW.apply_status = '2' AND (OLD.apply_status IS NULL OR OLD.apply_status <> '2') THEN
        UPDATE emp_user_profile
        SET employment_status = '2',
            update_by = IFNULL(NEW.update_by, 'system'),
            update_time = NOW()
        WHERE user_id = NEW.user_id;
    END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS trg_emp_training_record_ai;
DELIMITER $$
CREATE TRIGGER trg_emp_training_record_ai
    AFTER INSERT ON emp_training_record
    FOR EACH ROW
BEGIN

-- Data rows omitted from the public source snapshot.

END$$
DELIMITER ;

DROP TRIGGER IF EXISTS trg_emp_training_record_au;
DELIMITER $$
CREATE TRIGGER trg_emp_training_record_au
    AFTER UPDATE ON emp_training_record
    FOR EACH ROW
BEGIN
    IF NOT (NEW.record_status <=> OLD.record_status) THEN

-- Data rows omitted from the public source snapshot.

    END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS trg_emp_consult_ai;
DELIMITER $$
CREATE TRIGGER trg_emp_consult_ai
    AFTER INSERT ON emp_consultation
    FOR EACH ROW
BEGIN

-- Data rows omitted from the public source snapshot.

END$$
DELIMITER ;

DROP TRIGGER IF EXISTS trg_emp_consult_au;
DELIMITER $$
CREATE TRIGGER trg_emp_consult_au
    AFTER UPDATE ON emp_consultation
    FOR EACH ROW
BEGIN
    IF NOT (NEW.audit_status <=> OLD.audit_status)
        OR NOT (NEW.consult_status <=> OLD.consult_status)
        OR NOT (NEW.answer_content <=> OLD.answer_content) THEN

-- Data rows omitted from the public source snapshot.

    END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS trg_emp_policy_ai;
DELIMITER $$
CREATE TRIGGER trg_emp_policy_ai
    AFTER INSERT ON emp_policy
    FOR EACH ROW
BEGIN

-- Data rows omitted from the public source snapshot.

END$$
DELIMITER ;

DROP TRIGGER IF EXISTS trg_emp_policy_au;
DELIMITER $$
CREATE TRIGGER trg_emp_policy_au
    AFTER UPDATE ON emp_policy
    FOR EACH ROW
BEGIN
    IF NOT (NEW.audit_status <=> OLD.audit_status)
        OR NOT (NEW.status <=> OLD.status) THEN

-- Data rows omitted from the public source snapshot.

    END IF;
END$$
DELIMITER ;

-- ------------------------------------------------------------
-- D. 报表视图（管理端统计分析）
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW emp_v_report_overview AS
SELECT
    NOW() AS snapshot_time,
    p.profile_total,
    p.unemployed_total,
    p.employed_total,
    ROUND((p.unemployed_total / NULLIF(p.profile_total, 0)) * 100, 2) AS unemployment_rate_pct,
    a.apply_total,
    a.hired_total,
    ROUND((a.hired_total / NULLIF(a.apply_total, 0)) * 100, 2) AS employment_success_rate_pct,
    c.consult_total,
    c.replied_total,
    ROUND((c.replied_total / NULLIF(c.consult_total, 0)) * 100, 2) AS consult_reply_rate_pct,
    pol.policy_total,
    pol.latest_policy_time
FROM
    (
        SELECT
            COUNT(1) AS profile_total,
            SUM(CASE WHEN employment_status IN ('0', '1') THEN 1 ELSE 0 END) AS unemployed_total,
            SUM(CASE WHEN employment_status = '2' THEN 1 ELSE 0 END) AS employed_total
        FROM emp_user_profile
    ) p
        CROSS JOIN
    (
        SELECT
            COUNT(1) AS apply_total,
            SUM(CASE WHEN apply_status = '2' THEN 1 ELSE 0 END) AS hired_total
        FROM emp_position_apply
    ) a
        CROSS JOIN
    (
        SELECT
            COUNT(1) AS consult_total,
            SUM(CASE WHEN consult_status IN ('1', '2') THEN 1 ELSE 0 END) AS replied_total
        FROM emp_consultation
    ) c
        CROSS JOIN
    (
        SELECT
            COUNT(1) AS policy_total,
            MAX(publish_time) AS latest_policy_time
        FROM emp_policy
        WHERE audit_status = '1' AND status = '0'
    ) pol;

CREATE OR REPLACE VIEW emp_v_report_age AS
SELECT age_range AS name, cnt AS value
FROM (
         SELECT
             CASE
                 WHEN age IS NULL THEN '未知'
                 WHEN age < 25 THEN '25岁以下'
                 WHEN age BETWEEN 25 AND 34 THEN '25-34'
                 WHEN age BETWEEN 35 AND 44 THEN '35-44'
                 WHEN age BETWEEN 45 AND 54 THEN '45-54'
                 ELSE '55岁及以上'
                 END AS age_range,
             COUNT(1) AS cnt
         FROM emp_user_profile
         GROUP BY age_range
     ) x
ORDER BY value DESC;

CREATE OR REPLACE VIEW emp_v_report_district AS
SELECT
    COALESCE(d.dept_id, 0) AS dept_id,
    COALESCE(d.dept_name, '未分配') AS dept_name,
    COUNT(p.profile_id) AS profile_total,
    SUM(CASE WHEN p.employment_status IN ('0', '1') THEN 1 ELSE 0 END) AS unemployed_total,
    SUM(CASE WHEN p.employment_status = '2' THEN 1 ELSE 0 END) AS employed_total,
    ROUND(
            (SUM(CASE WHEN p.employment_status IN ('0', '1') THEN 1 ELSE 0 END) / NULLIF(COUNT(p.profile_id), 0)) * 100,
            2
    ) AS unemployment_rate_pct
FROM emp_user_profile p
         LEFT JOIN sys_user u ON p.user_id = u.user_id
         LEFT JOIN sys_dept d ON u.dept_id = d.dept_id
GROUP BY COALESCE(d.dept_id, 0), COALESCE(d.dept_name, '未分配')
ORDER BY unemployment_rate_pct DESC, profile_total DESC;

CREATE OR REPLACE VIEW emp_v_report_apply_month AS
SELECT
    DATE_FORMAT(apply_time, '%Y-%m') AS stat_month,
    COUNT(1) AS apply_total,
    SUM(CASE WHEN apply_status = '2' THEN 1 ELSE 0 END) AS hired_total,
    ROUND((SUM(CASE WHEN apply_status = '2' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0)) * 100, 2) AS hire_rate_pct
FROM emp_position_apply
GROUP BY DATE_FORMAT(apply_time, '%Y-%m')
ORDER BY stat_month DESC;

-- ------------------------------------------------------------
-- E. 字典补充（咨询类型标准化）
-- ------------------------------------------------------------

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- 补丁结束。

-- ============================================================
-- 街道待就业人员管理服务系统
-- 就业子系统联动增强补丁 V2（中文增量脚本）
-- 日期：2026-02-22
-- 目标：
-- 1）岗位投递前置校验（档案审核、岗位发布状态）
-- 2）培训报名前置校验（审核状态、报名状态、名额上限）
-- 3）咨询审核驳回自动关闭；未审核通过禁止回复
-- ============================================================

-- ------------------------------------------------------------
-- 一、岗位投递校验触发器（防止绕过应用层直接写库）
-- ------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_emp_apply_bi_guard;
DELIMITER $$
CREATE TRIGGER trg_emp_apply_bi_guard
    BEFORE INSERT ON emp_position_apply
    FOR EACH ROW
BEGIN
    DECLARE v_profile_audit CHAR(1);
    DECLARE v_position_audit CHAR(1);
    DECLARE v_position_publish CHAR(1);

    SELECT p.audit_status
    INTO v_profile_audit
    FROM emp_user_profile p
    WHERE p.user_id = NEW.user_id
    LIMIT 1;

    IF v_profile_audit IS NULL OR v_profile_audit <> '1' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '个人档案未审核通过，禁止投递岗位';
    END IF;

    SELECT ep.audit_status, ep.publish_status
    INTO v_position_audit, v_position_publish
    FROM emp_position ep
    WHERE ep.position_id = NEW.position_id
    LIMIT 1;

    IF v_position_audit IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '岗位不存在，禁止投递';
    END IF;

    IF v_position_audit <> '1' OR v_position_publish <> '0' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '岗位未发布或未审核通过，禁止投递';
    END IF;
END$$
DELIMITER ;

-- ------------------------------------------------------------
-- 二、培训报名校验触发器（状态与名额双校验）
-- ------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_emp_training_record_bi_guard;
DELIMITER $$
CREATE TRIGGER trg_emp_training_record_bi_guard
    BEFORE INSERT ON emp_training_record
    FOR EACH ROW
BEGIN
    DECLARE v_profile_audit CHAR(1);
    DECLARE v_training_audit CHAR(1);
    DECLARE v_training_status CHAR(1);
    DECLARE v_quota INT;
    DECLARE v_signup_count INT;

    SELECT p.audit_status
    INTO v_profile_audit
    FROM emp_user_profile p
    WHERE p.user_id = NEW.user_id
    LIMIT 1;

    IF v_profile_audit IS NULL OR v_profile_audit <> '1' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '个人档案未审核通过，禁止报名培训';
    END IF;

    SELECT t.audit_status, t.status, t.quota, t.signup_count
    INTO v_training_audit, v_training_status, v_quota, v_signup_count
    FROM emp_training t
    WHERE t.training_id = NEW.training_id
    LIMIT 1;

    IF v_training_audit IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '培训计划不存在，禁止报名';
    END IF;

    IF v_training_audit <> '1' OR v_training_status <> '0' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '培训未开放报名或未审核通过';
    END IF;

    IF v_quota IS NOT NULL AND v_quota > 0 AND v_signup_count >= v_quota THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '培训名额已满';
    END IF;
END$$
DELIMITER ;

-- ------------------------------------------------------------
-- 三、咨询审核与回复联动触发器
-- 1）驳回即自动关闭咨询
-- 2）未审核通过禁止写入回复内容
-- ------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_emp_consult_bu_guard;
DELIMITER $$
CREATE TRIGGER trg_emp_consult_bu_guard
    BEFORE UPDATE ON emp_consultation
    FOR EACH ROW
BEGIN
    IF NEW.audit_status = '2' THEN
        SET NEW.consult_status = '2';
    END IF;

    IF NEW.answer_content IS NOT NULL
        AND NEW.answer_content <> ''
        AND (NEW.audit_status IS NULL OR NEW.audit_status <> '1') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '咨询未审核通过，禁止回复';
    END IF;
END$$
DELIMITER ;

-- 脚本结束

-- 就业子系统联动增强补丁
DROP PROCEDURE IF EXISTS sp_emp_add_index_v3;
DELIMITER $$
CREATE PROCEDURE sp_emp_add_index_v3(
    IN p_table_name VARCHAR(64),
    IN p_index_name VARCHAR(64),
    IN p_cols VARCHAR(255)
)
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = p_table_name
          AND index_name = p_index_name
    ) THEN
        SET @sql_stmt = CONCAT(
                'ALTER TABLE `', p_table_name,
                '` ADD INDEX `', p_index_name,
                '` (', p_cols, ')'
                        );
        PREPARE stmt FROM @sql_stmt;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END$$
DELIMITER ;

CALL sp_emp_add_index_v3('emp_flow_log', 'idx_emp_flow_action_time', 'action_type, operate_time');
CALL sp_emp_add_index_v3('emp_flow_log', 'idx_emp_flow_operator_time', 'operator_name, operate_time');

DROP PROCEDURE IF EXISTS sp_emp_add_index_v3;

-- 脚本结束

-- 一、流程日志索引增强（支持日/周趋势与筛选）
DROP PROCEDURE IF EXISTS sp_emp_add_index_v4;
DELIMITER $$
CREATE PROCEDURE sp_emp_add_index_v4(
    IN p_table_name VARCHAR(64),
    IN p_index_name VARCHAR(64),
    IN p_cols VARCHAR(255)
)
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = p_table_name
          AND index_name = p_index_name
    ) THEN
        SET @sql_stmt = CONCAT(
                'ALTER TABLE `', p_table_name,
                '` ADD INDEX `', p_index_name,
                '` (', p_cols, ')'
                        );
        PREPARE stmt FROM @sql_stmt;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END$$
DELIMITER ;

CALL sp_emp_add_index_v4('emp_flow_log', 'idx_emp_flow_operate_time', 'operate_time');
CALL sp_emp_add_index_v4('emp_flow_log', 'idx_emp_flow_biz_time', 'biz_type, operate_time');

DROP PROCEDURE IF EXISTS sp_emp_add_index_v4;

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


ALTER TABLE sys_user
    MODIFY COLUMN avatar varchar(100) DEFAULT '' COMMENT '头像图片路径';

ALTER TABLE emp_user_profile
    MODIFY COLUMN certificate_urls text COMMENT '技能证书图片路径（逗号分隔）';


-- Patch: add cover image column for employment policy
-- Safe to run multiple times.

SET @col_exists := (
    SELECT COUNT(1)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'emp_policy'
      AND column_name = 'cover_url'
);

SET @ddl_sql := IF(
        @col_exists = 0,
        'ALTER TABLE emp_policy ADD COLUMN cover_url varchar(255) DEFAULT '''' COMMENT ''policy cover image'' AFTER policy_tag',
        'ALTER TABLE emp_policy MODIFY COLUMN cover_url varchar(255) DEFAULT '''' COMMENT ''policy cover image'''
                );

PREPARE stmt_cover_url FROM @ddl_sql;
EXECUTE stmt_cover_url;
DEALLOCATE PREPARE stmt_cover_url;

-- Optional normalization for existing rows.
UPDATE emp_policy
SET cover_url = ''
WHERE cover_url IS NULL;

-- Patch: add resume_attachment_url to emp_user_profile
-- Date: 2026-02-22
-- Note: standalone supplement SQL, does not modify original schema script

SET @col_exists := (
    SELECT COUNT(1)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'emp_user_profile'
      AND COLUMN_NAME = 'resume_attachment_url'
);

SET @ddl_sql := IF(
        @col_exists = 0,
        'ALTER TABLE emp_user_profile ADD COLUMN resume_attachment_url varchar(500) NOT NULL DEFAULT '''' COMMENT ''Resume attachment URL'' AFTER certificate_urls',
        'SELECT ''resume_attachment_url already exists'' AS msg'
                );

PREPARE stmt FROM @ddl_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

UPDATE emp_user_profile
SET resume_attachment_url = ''
WHERE resume_attachment_url IS NULL;

-- 1) 将状态值 1 调整为“已完成”
update sys_dict_data
set dict_label = '已完成',
    list_class = 'success',
    remark = '培训已完成',
    update_by = 'admin',
    update_time = sysdate()
where dict_type = 'emp_training_status'
  and dict_value = '1';

-- 2) 将状态值 2 调整为“缺席”
update sys_dict_data
set dict_label = '缺席',
    list_class = 'danger',
    remark = '培训缺席',
    update_by = 'admin',
    update_time = sysdate()
where dict_type = 'emp_training_status'
  and dict_value = '2';

-- Patch: convert seed_test media paths to local visible files
-- Date: 2026-02-22
-- Prerequisite: local files exist under /profile/upload/2026/02/seed_*

SET @seed_by := 'seed_test';

-- 1) seed users avatar
UPDATE sys_user
SET avatar = '/profile/upload/2026/02/seed_avatar_01.png'
WHERE user_name = 'seed_u01';
UPDATE sys_user
SET avatar = '/profile/upload/2026/02/seed_avatar_02.png'
WHERE user_name = 'seed_u02';
UPDATE sys_user
SET avatar = '/profile/upload/2026/02/seed_avatar_03.png'
WHERE user_name = 'seed_u03';
UPDATE sys_user
SET avatar = '/profile/upload/2026/02/seed_avatar_04.png'
WHERE user_name = 'seed_u04';
UPDATE sys_user
SET avatar = '/profile/upload/2026/02/seed_avatar_05.png'
WHERE user_name = 'seed_u05';
UPDATE sys_user
SET avatar = '/profile/upload/2026/02/seed_avatar_06.png'
WHERE user_name = 'seed_u06';
UPDATE sys_user
SET avatar = '/profile/upload/2026/02/seed_avatar_07.png'
WHERE user_name = 'seed_u07';
UPDATE sys_user
SET avatar = '/profile/upload/2026/02/seed_avatar_08.png'
WHERE user_name = 'seed_u08';
UPDATE sys_user
SET avatar = '/profile/upload/2026/02/seed_avatar_09.png'
WHERE user_name = 'seed_u09';
UPDATE sys_user
SET avatar = '/profile/upload/2026/02/seed_avatar_10.png'
WHERE user_name = 'seed_u10';

-- 2) seed profile cert + resume attachment
UPDATE emp_user_profile p
    JOIN sys_user u ON u.user_id = p.user_id
SET p.certificate_urls = '/profile/upload/2026/02/seed_cert_01a.png,/profile/upload/2026/02/seed_cert_01b.png',
    p.resume_attachment_url = '/profile/upload/2026/02/seed_resume_01.pdf',
    p.update_by = @seed_by,
    p.update_time = SYSDATE()
WHERE u.user_name = 'seed_u01';

UPDATE emp_user_profile p
    JOIN sys_user u ON u.user_id = p.user_id
SET p.certificate_urls = '/profile/upload/2026/02/seed_cert_02a.png',
    p.resume_attachment_url = '/profile/upload/2026/02/seed_resume_02.pdf',
    p.update_by = @seed_by,
    p.update_time = SYSDATE()
WHERE u.user_name = 'seed_u02';

UPDATE emp_user_profile p
    JOIN sys_user u ON u.user_id = p.user_id
SET p.certificate_urls = '/profile/upload/2026/02/seed_cert_03a.png',
    p.resume_attachment_url = '/profile/upload/2026/02/seed_resume_03.pdf',
    p.update_by = @seed_by,
    p.update_time = SYSDATE()
WHERE u.user_name = 'seed_u03';

UPDATE emp_user_profile p
    JOIN sys_user u ON u.user_id = p.user_id
SET p.certificate_urls = '/profile/upload/2026/02/seed_cert_04a.png,/profile/upload/2026/02/seed_cert_04b.png',
    p.resume_attachment_url = '/profile/upload/2026/02/seed_resume_04.pdf',
    p.update_by = @seed_by,
    p.update_time = SYSDATE()
WHERE u.user_name = 'seed_u04';

UPDATE emp_user_profile p
    JOIN sys_user u ON u.user_id = p.user_id
SET p.certificate_urls = '/profile/upload/2026/02/seed_cert_05a.png',
    p.resume_attachment_url = '/profile/upload/2026/02/seed_resume_05.pdf',
    p.update_by = @seed_by,
    p.update_time = SYSDATE()
WHERE u.user_name = 'seed_u05';

UPDATE emp_user_profile p
    JOIN sys_user u ON u.user_id = p.user_id
SET p.certificate_urls = '/profile/upload/2026/02/seed_cert_06a.png',
    p.resume_attachment_url = '/profile/upload/2026/02/seed_resume_06.pdf',
    p.update_by = @seed_by,
    p.update_time = SYSDATE()
WHERE u.user_name = 'seed_u06';

UPDATE emp_user_profile p
    JOIN sys_user u ON u.user_id = p.user_id
SET p.certificate_urls = '/profile/upload/2026/02/seed_cert_07a.png',
    p.resume_attachment_url = '/profile/upload/2026/02/seed_resume_07.pdf',
    p.update_by = @seed_by,
    p.update_time = SYSDATE()
WHERE u.user_name = 'seed_u07';

UPDATE emp_user_profile p
    JOIN sys_user u ON u.user_id = p.user_id
SET p.certificate_urls = '/profile/upload/2026/02/seed_cert_08a.png',
    p.resume_attachment_url = '/profile/upload/2026/02/seed_resume_08.pdf',
    p.update_by = @seed_by,
    p.update_time = SYSDATE()
WHERE u.user_name = 'seed_u08';

UPDATE emp_user_profile p
    JOIN sys_user u ON u.user_id = p.user_id
SET p.certificate_urls = '/profile/upload/2026/02/seed_cert_09a.png',
    p.resume_attachment_url = '/profile/upload/2026/02/seed_resume_09.pdf',
    p.update_by = @seed_by,
    p.update_time = SYSDATE()
WHERE u.user_name = 'seed_u09';

UPDATE emp_user_profile p
    JOIN sys_user u ON u.user_id = p.user_id
SET p.certificate_urls = '/profile/upload/2026/02/seed_cert_10a.png',
    p.resume_attachment_url = '/profile/upload/2026/02/seed_resume_10.pdf',
    p.update_by = @seed_by,
    p.update_time = SYSDATE()
WHERE u.user_name = 'seed_u10';

-- 3) seed policy cover + rich text image
UPDATE emp_policy
SET cover_url = '/profile/upload/2026/02/seed_policy_cover_01.png',
    content = REPLACE(content, 'https://picsum.photos/seed/policy_detail_01/760/360', '/profile/upload/2026/02/seed_policy_detail_01.png'),
    update_by = @seed_by,
    update_time = SYSDATE()
WHERE title = '2026年高校毕业生就业见习补贴实施细则' AND create_by = @seed_by;

UPDATE emp_policy
SET cover_url = '/profile/upload/2026/02/seed_policy_cover_02.png',
    update_by = @seed_by,
    update_time = SYSDATE()
WHERE title = '2026年灵活就业社保补贴申报指南' AND create_by = @seed_by;

UPDATE emp_policy
SET cover_url = '/profile/upload/2026/02/seed_policy_cover_03.png',
    update_by = @seed_by,
    update_time = SYSDATE()
WHERE title = '创业担保贷款贴息政策解读' AND create_by = @seed_by;

UPDATE emp_policy
SET cover_url = '/profile/upload/2026/02/seed_policy_cover_04.png',
    update_by = @seed_by,
    update_time = SYSDATE()
WHERE title = '就业困难人员公益性岗位安置通知' AND create_by = @seed_by;

UPDATE emp_policy
SET cover_url = '/profile/upload/2026/02/seed_policy_cover_05.png',
    update_by = @seed_by,
    update_time = SYSDATE()
WHERE title = '青年创业孵化场地减免办法' AND create_by = @seed_by;

UPDATE emp_policy
SET cover_url = '/profile/upload/2026/02/seed_policy_cover_06.png',
    update_by = @seed_by,
    update_time = SYSDATE()
WHERE title = '职业技能提升补贴常见问题' AND create_by = @seed_by;

UPDATE emp_policy
SET cover_url = '/profile/upload/2026/02/seed_policy_cover_07.png',
    update_by = @seed_by,
    update_time = SYSDATE()
WHERE title = '街道就业驿站建设推进方案（草案）' AND create_by = @seed_by;

UPDATE emp_policy
SET cover_url = '/profile/upload/2026/02/seed_policy_cover_08.png',
    update_by = @seed_by,
    update_time = SYSDATE()
WHERE title = '一次性创业补贴申报口径说明（内部）' AND create_by = @seed_by;

UPDATE emp_policy
SET cover_url = '/profile/upload/2026/02/seed_policy_cover_09.png',
    update_by = @seed_by,
    update_time = SYSDATE()
WHERE title = '就业服务大厅节假日值班安排' AND create_by = @seed_by;

UPDATE emp_policy
SET cover_url = '/profile/upload/2026/02/seed_policy_cover_10.png',
    update_by = @seed_by,
    update_time = SYSDATE()
WHERE title = '2026年高校毕业生创业扶持政策合集' AND create_by = @seed_by;

-- 4) seed consultation image in rich text answer
UPDATE emp_consultation
SET answer_content = REPLACE(answer_content, 'https://picsum.photos/seed/consult_policy_1/360/180', '/profile/upload/2026/02/seed_consult_01.png'),
    update_by = @seed_by,
    update_time = SYSDATE()
WHERE create_by = @seed_by;

-- 5) verify
SELECT 'seed local media file refs in profile' AS item, COUNT(1) AS cnt
FROM emp_user_profile
WHERE certificate_urls LIKE '%/profile/upload/2026/02/seed_cert_%'
   OR resume_attachment_url LIKE '%/profile/upload/2026/02/seed_resume_%';

SELECT 'seed local media file refs in policy' AS item, COUNT(1) AS cnt
FROM emp_policy
WHERE create_by = @seed_by
  AND cover_url LIKE '/profile/upload/2026/02/seed_policy_cover_%';

-- ============================================================
-- 全系统测试数据补丁（独立新增，不修改原有 SQL）
-- 文件: sql/patch_full_test_data_visible_20260222.sql
-- 日期: 2026-02-22
-- 目标:
-- 1) 一次性插入多条可联动测试数据（用户/档案/岗位/投递/培训/咨询/政策/公告）
-- 2) 图片与 PDF 使用本地真实可访问路径（/profile/upload/2026/02/seed_*）
-- 3) 幂等执行：同批次数据可重复刷新
-- ============================================================

SET NAMES utf8mb4;

SET @seed_by := 'seed_batch_20260222';
SET @now := SYSDATE();
SET @pwd := '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2';

-- ----------------------------
-- A) 字段补齐（幂等）
-- ----------------------------
SET @col_resume_exists := (
    SELECT COUNT(1)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'emp_user_profile'
      AND COLUMN_NAME = 'resume_attachment_url'
);
SET @sql_resume := IF(
        @col_resume_exists = 0,
        'ALTER TABLE emp_user_profile ADD COLUMN resume_attachment_url varchar(500) NOT NULL DEFAULT '''' COMMENT ''Resume attachment URL'' AFTER certificate_urls',
        'SELECT ''resume_attachment_url exists'' AS msg'
                   );
PREPARE stmt_resume FROM @sql_resume;
EXECUTE stmt_resume;
DEALLOCATE PREPARE stmt_resume;

SET @col_cover_exists := (
    SELECT COUNT(1)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'emp_policy'
      AND COLUMN_NAME = 'cover_url'
);
SET @sql_cover := IF(
        @col_cover_exists = 0,
        'ALTER TABLE emp_policy ADD COLUMN cover_url varchar(255) DEFAULT '''' COMMENT ''policy cover image'' AFTER policy_tag',
        'SELECT ''cover_url exists'' AS msg'
                  );
PREPARE stmt_cover FROM @sql_cover;
EXECUTE stmt_cover;
DEALLOCATE PREPARE stmt_cover;

-- ----------------------------
-- B) 清理同批次旧数据（幂等）
-- ----------------------------
DELETE tr
FROM emp_training_record tr
         LEFT JOIN sys_user u ON u.user_id = tr.user_id
         LEFT JOIN emp_training t ON t.training_id = tr.training_id
WHERE tr.create_by = @seed_by
   OR u.user_name IN ('seed_u01','seed_u02','seed_u03','seed_u04','seed_u05','seed_u06','seed_u07','seed_u08','seed_u09','seed_u10')
   OR t.create_by = @seed_by;

DELETE pa
FROM emp_position_apply pa
         LEFT JOIN sys_user u ON u.user_id = pa.user_id
         LEFT JOIN emp_position p ON p.position_id = pa.position_id
WHERE pa.create_by = @seed_by
   OR u.user_name IN ('seed_u01','seed_u02','seed_u03','seed_u04','seed_u05','seed_u06','seed_u07','seed_u08','seed_u09','seed_u10')
   OR p.create_by = @seed_by;

DELETE FROM emp_consultation WHERE create_by = @seed_by;
DELETE FROM emp_policy WHERE create_by = @seed_by;
DELETE FROM emp_training WHERE create_by = @seed_by;
DELETE FROM emp_position WHERE create_by = @seed_by;

DELETE p
FROM emp_user_profile p
         JOIN sys_user u ON u.user_id = p.user_id
WHERE u.user_name IN ('seed_u01','seed_u02','seed_u03','seed_u04','seed_u05','seed_u06','seed_u07','seed_u08','seed_u09','seed_u10')
   OR p.create_by = @seed_by;

DELETE ur
FROM sys_user_role ur
         JOIN sys_user u ON u.user_id = ur.user_id
WHERE u.user_name IN ('seed_u01','seed_u02','seed_u03','seed_u04','seed_u05','seed_u06','seed_u07','seed_u08','seed_u09','seed_u10');

DELETE up
FROM sys_user_post up
         JOIN sys_user u ON u.user_id = up.user_id
WHERE u.user_name IN ('seed_u01','seed_u02','seed_u03','seed_u04','seed_u05','seed_u06','seed_u07','seed_u08','seed_u09','seed_u10');

DELETE FROM sys_user
WHERE user_name IN ('seed_u01','seed_u02','seed_u03','seed_u04','seed_u05','seed_u06','seed_u07','seed_u08','seed_u09','seed_u10');

DELETE FROM sys_notice WHERE create_by = @seed_by;

-- ----------------------------
-- C) 测试账号（10个）
-- ----------------------------

-- Data rows omitted from the public source snapshot.


SET @role_common := IFNULL((SELECT role_id FROM sys_role WHERE role_key = 'common' LIMIT 1), 2);
SET @post_user := IFNULL((SELECT post_id FROM sys_post WHERE post_code = 'user' LIMIT 1), 4);

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- ----------------------------
-- D) 人员档案（含证书图 + PDF简历附件）
-- ----------------------------

-- Data rows omitted from the public source snapshot.


-- ----------------------------
-- E) 岗位 + 投递记录
-- ----------------------------

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- ----------------------------
-- F) 培训 + 培训记录
-- ----------------------------

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


UPDATE emp_training t
SET signup_count = (
    SELECT COUNT(1) FROM emp_training_record r WHERE r.training_id = t.training_id
)
WHERE t.create_by = @seed_by;

-- ----------------------------
-- G) 互动咨询（含富文本回复图片）
-- ----------------------------

-- Data rows omitted from the public source snapshot.


-- ----------------------------
-- H) 政策资讯（含封面图 + 正文富文本图片）
-- ----------------------------

-- Data rows omitted from the public source snapshot.


-- ----------------------------
-- I) 系统公告（首页“查看更多”可读取）
-- ----------------------------

-- Data rows omitted from the public source snapshot.


-- ----------------------------
-- J) 核验查询
-- ----------------------------
SELECT 'sys_user' AS item, COUNT(1) AS cnt FROM sys_user WHERE create_by = @seed_by
UNION ALL
SELECT 'emp_user_profile', COUNT(1) FROM emp_user_profile WHERE create_by = @seed_by
UNION ALL
SELECT 'emp_position', COUNT(1) FROM emp_position WHERE create_by = @seed_by
UNION ALL
SELECT 'emp_position_apply', COUNT(1) FROM emp_position_apply WHERE create_by = @seed_by
UNION ALL
SELECT 'emp_training', COUNT(1) FROM emp_training WHERE create_by = @seed_by
UNION ALL
SELECT 'emp_training_record', COUNT(1) FROM emp_training_record WHERE create_by = @seed_by
UNION ALL
SELECT 'emp_consultation', COUNT(1) FROM emp_consultation WHERE create_by = @seed_by
UNION ALL
SELECT 'emp_policy', COUNT(1) FROM emp_policy WHERE create_by = @seed_by
UNION ALL
SELECT 'sys_notice', COUNT(1) FROM sys_notice WHERE create_by = @seed_by;

SELECT user_name, avatar
FROM sys_user
WHERE create_by = @seed_by
ORDER BY user_name;

SELECT real_name, certificate_urls, resume_attachment_url
FROM emp_user_profile
WHERE create_by = @seed_by
ORDER BY profile_id
LIMIT 10;

SELECT title, cover_url
FROM emp_policy
WHERE create_by = @seed_by
ORDER BY publish_time DESC;

-- ============================================================
-- 就业子系统：咨询类型标准化修复补丁
-- 日期：2026-02-22
-- 作用：
-- 1) 统一字典 emp_consult_type 为 JOB/TRAINING/POLICY/OTHER
-- 2) 修复历史咨询数据中 consult_type 为 0/1/2/3 或中文值的问题
-- ============================================================

SET NAMES utf8mb4;
START TRANSACTION;

-- 1) 确保字典类型存在

-- Data rows omitted from the public source snapshot.


-- 2) 清理旧口径字典值（数值与中文值）
DELETE FROM sys_dict_data
WHERE dict_type = 'emp_consult_type'
  AND dict_value IN ('0', '1', '2', '3', '岗位申请', '培训报名', '政策咨询', '其他', '账户问题', '岗位咨询', '培训咨询');

-- 3) 写入标准字典值

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- 4) 修复历史数据 consult_type
UPDATE emp_consultation
SET consult_type = CASE
                       WHEN consult_type IS NULL OR TRIM(consult_type) = '' THEN 'OTHER'
                       WHEN UPPER(TRIM(consult_type)) IN ('JOB', '0') THEN 'JOB'
                       WHEN UPPER(TRIM(consult_type)) IN ('TRAINING', '1') THEN 'TRAINING'
                       WHEN UPPER(TRIM(consult_type)) IN ('POLICY', '2') THEN 'POLICY'
                       WHEN UPPER(TRIM(consult_type)) IN ('OTHER', '3') THEN 'OTHER'
                       WHEN TRIM(consult_type) IN ('岗位咨询', '岗位申请', '求职咨询') THEN 'JOB'
                       WHEN TRIM(consult_type) IN ('培训咨询', '培训报名') THEN 'TRAINING'
                       WHEN TRIM(consult_type) IN ('政策咨询') THEN 'POLICY'
                       WHEN TRIM(consult_type) IN ('其他', '账户问题') THEN 'OTHER'
                       ELSE 'OTHER'
    END,
    update_by = 'sql_patch_20260222',
    update_time = SYSDATE();

COMMIT;

-- 5) 自检结果
SELECT consult_type, COUNT(1) AS cnt
FROM emp_consultation
GROUP BY consult_type
ORDER BY consult_type;

