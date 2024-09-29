require 'fiddle'
require 'fiddle/import'

module WinAPI
  extend Fiddle::Importer
  dlload 'user32'
  extern 'void keybd_event(unsigned char, unsigned char, unsigned int, unsigned int)'
end

# 仮想キーコードの定義
VK_SHIFT = 0x10

# 文字の仮想キーコードとShiftキーが必要かどうかを判定する関数
def get_vk_code(char)
  case char
  when 'A'..'Z'
    [char.ord, true]  # 大文字の場合はShiftキーが必要
  when 'a'..'z'
    [char.upcase.ord, false]  # 小文字はそのままキーコードを取得
  when '0'..'9'
    # 数字に対応する仮想キーコード
    case char
    when '0' then [0x30, false]
    when '1' then [0x31, false]
    when '2' then [0x32, false]
    when '3' then [0x33, false]
    when '4' then [0x34, false]
    when '5' then [0x35, false]
    when '6' then [0x36, false]
    when '7' then [0x37, false]
    when '8' then [0x38, false]
    when '9' then [0x39, false]
    end
  when ' '
    [0x20, false]  # スペースキー
  else
    # 記号や特殊文字をここで対応
    case char
    when '!' then [0x31, true]     # Shift + 1
    when '@' then [0x32, true]     # Shift + 2
    when '#' then [0x33, true]     # Shift + 3
    when '$' then [0x34, true]     # Shift + 4
    when '%' then [0x35, true]     # Shift + 5
    when '^' then [0x36, true]     # Shift + 6
    when '&' then [0x37, true]     # Shift + 7
    when '*' then [0x38, true]     # Shift + 8
    when '(' then [0x39, true]     # Shift + 9
    when ')' then [0x30, true]     # Shift + 0
    when '-' then [0xBD, false]    # ハイフン
    when '_' then [0xBD, true]     # Shift + ハイフン
    when '=' then [0xBB, false]    # イコール
    when '+' then [0xBB, true]     # Shift + イコール
    when '[' then [0xDB, false]    # 左角括弧
    when '{' then [0xDB, true]     # Shift + 左角括弧
    when ']' then [0xDD, false]    # 右角括弧
    when '}' then [0xDD, true]     # Shift + 右角括弧
    when '\\' then [0xDC, false]   # バックスラッシュ
    when '|' then [0xDC, true]     # Shift + バックスラッシュ
    when ';' then [0xBA, false]    # セミコロン
    when ':' then [0xBA, true]     # Shift + セミコロン
    when "'" then [0xDE, false]    # アポストロフィ
    when '"' then [0xDE, true]     # Shift + アポストロフィ
    when ',' then [0xBC, false]    # カンマ
    when '<' then [0xBC, true]     # Shift + カンマ
    when '.' then [0xBE, false]    # ピリオド
    when '>' then [0xBE, true]     # Shift + ピリオド
    when '/' then [0xBF, false]    # スラッシュ
    when '?' then [0xBF, true]     # Shift + スラッシュ
    else
      [char.ord, false]  # その他の文字はそのままキーコードを使用
    end
  end
end

# キーを押す関数
def key_down(vk_code)
  WinAPI.keybd_event(vk_code, 0, 0, 0)
end

# キーを離す関数
def key_up(vk_code)
  WinAPI.keybd_event(vk_code, 0, 0x0002, 0)
end

# テキストを自動入力する関数
def typing(text)
  sleep 0.1  # テキスト入力前の待機時間
  text.each_char do |char|
    vk_code, shift_required = get_vk_code(char)

    if shift_required
      key_down(VK_SHIFT)  # Shiftキーを押す
    end

    key_down(vk_code)  # 文字のキーを押す
    sleep(0.05)        # キーが押された状態を少し保持
    key_up(vk_code)    # 文字のキーを離す

    if shift_required
      key_up(VK_SHIFT)  # Shiftキーを離す
    end

    sleep(0.01)  # 文字ごとに少し待機
  end
end
