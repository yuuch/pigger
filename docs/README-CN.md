# pigger

用 golang 编写的静态博客生成器

# 项目简介

写该项目有如下几个原因:

- 实践 golang 语言
- 希望写一个适合自己的, 可以自定义的静态博客生成器, 其功能应该有如下几个
    - 基于 markdown 语法并做适当扩展
    - 博文应该是文本友好型, 也就是说, 一篇博文, 在浏览器中和用文本编辑器打开时,
        都能够给人带来舒适的阅读体验, 因此对文本书写格式有要求,
        但是 markdown 语法还是略显复杂
    - 不支持表格, 因为文本不友好
    - 在保证渲染一致的情况下, 能够生成单 HTML 页面以及导出为 PDF

# TODO

- 文本到 HTML 的渲染 (✓)
- 解析文章头(标题, 作者, 时间) (✓)
- 实现列表的渲染 (✓)
- 捆绑静态资源实现代码高亮(css, js 等)(✓)
- 行内代码块渲染(✓)
- 独立代码块(✓)
- 列表内代码块渲染(✓)
- HTML 标记转义(✓)
- UTF-8 字符处理(✓)
- @ 语法自动插入图片(支持 .gif, .png, .jpg, .jpeg, .svg 图片后缀)功能 (✓)
- @ 语法插入超链接功能(除去检测上述图片外, 其他的均视作一个超链接),
    如果链接长度超过 32, 则后续部分以三个省略号来表示 (✓)
- 静态博客单篇文章生成(✓)
  - 生成一篇完全独立的文章:
  是指一篇文章包含了所有所需的资源: 样式表, 脚本文件, 图片文件, 方便分发.
  这也是默认模式.
  - 生成一篇半独立的文章:
  要使用这种模式, 可以使用 `-x` 选项. 这种方式下, 仅包含文章用到图片文件.
  样式表和脚本文件位于远程服务器上面. 指定的路径则有相对和绝对方式.
      - 相对路径, 默认配置文件位于文章的上一级目录中的 `pigger` 目录中.
      - 绝对路径, 需要使用 `--style <remote url>`声明一个远程服务器上的 URL.
  无论是相对路径还是绝对路径, 声明的目录下面均要包含专用目录 `css` 和 `js` 目录.
  专用文件夹只支持单级目录
- 简单静态博客生成(✓)
- 代码块空行功能(✓)
- 迁移功能(✓)
- 站点更新内置样式(✓)
- 方便查看源文件, 只需在文章链接末尾加上一个 `.txt` 后缀, 即可查看原来的文本文件(✓)
- 设置缺省标题(✓)
- 导出 PDF
- 实时渲染服务(计划采用 fsnotify 库实现)
- 添加用户自定义样式文件

# 功能与格式

- 只支持文本文件(必须以 `.txt` 为后缀)

- 不支持表格, 因为单独打开文本进行查看的时候不方便

- 列表渲染
    列表的第一行如果如果末尾字符为冒号(忽略右侧空格), 则表示换行,
    也就是说此时列表的第一行作为一个简短的小标题.

- 代码格式化
    行内格式化时使用两个反斜号将待格式化的文本括起来,
    如果想在行内显示一个反斜号, 请务必保证该行只有一个反斜号.

    如果想使用一整段独立的代码, 则可以使用 tab 缩进(四个空格),
    第一行使用 `//:` 来指明高亮的语言, 改行在实际显示时将会被忽略,
    且改行是可选的, 默认的高亮采用的是 C 语言家族. 比如

    ```
    //: c++
    #include <iostream>
    using namspace std;
    int main() {
        cout << "Hello pigger" << endl;
        return 0;
    }
    ```

    列表中也可以使用代码块, 采用 8 个缩进即可.

- 文章元信息(meta info)
    在文章开头处用 `---` 组成一个节区, 写入相关信息, 可写的信息如下,
    标 `*` 的表示必选, 其他选项暂不支持.

    ```
    ---
    - title: *
    - author: *
    - date: *
    ---
    ```
    日期的格式必须是 `年-月-日`, 比如 `2018-08-04`, 位数依次为 4, 2, 2 位.
    文章将按照时间将最新的文章放在最前面.
    

- 链接

    使用 `@[url]` 表示一个链接, url 必须以 http 或者 ftp 开头, 最终会被渲染成一个 a 标签.
    对于其他情况,  则视作图片渲染成 img 标签并拷贝图片.

# missing features

- 对于类似于 bash 中的 here doc 从文本复制时, 需要注意前缀空格不能有, 需要块复制.

# 编译

## 静态资源打包

    // 安装工具
    go get -u github.com/gobuffalo/packr/packr
    // 安装包
    go get -u github.com/gobuffalo/packr
    // 生成静态资源
    packr
    // 清理资源
    packr clean

## 多平台编译

安装 gox 编译包, 即可一键执行 gox 编译所有平台.

    // 安装
    go get github.com/mitchellh/gox
    // 编译 linux, windows, mac 三个平台的可执行文件, 放到 release 目录下面
    gox -output="release/{{.Dir}}_{{.OS}}_{{.Arch}}" -os="linux windows darwin" -arch="amd64 386"
    
# 迁移

从其他平台迁移过来后, 应该将整个要迁移的文章放置到 migration 目录,
并且在其下有一个 index.json, index.json 中的每个元素包含了一篇文章元信息:
应该包含: 文章名称, 文章文件相对于 migration 的位置, 文章日期, 文章作者,
比如

    {
        {
            "title": "TITLE"
            "author": "AUTHOR",
            "link": "LOCATION",
            "date": "DATE"
        }
    }
