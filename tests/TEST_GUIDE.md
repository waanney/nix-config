# 🧪 HƯỚNG DẪN TEST CÁC TÍNH NĂNG NEOVIM MỚI

File này hướng dẫn bạn test toàn bộ các plugin mới được cấu hình trong Neovim.

---

## 📑 Danh mục các bài test

| File test | Nội dung test | Plugin liên quan |
| :--- | :--- | :--- |
| [`test_completion.lua`](file:///etc/nixos/tests/test_completion.lua) | Gợi ý code siêu tốc, Snippet, Lazydev Lua | `blink.cmp`, `lazydev`, `lua_ls` |
| [`test_formatting.ts`](file:///etc/nixos/tests/test_formatting.ts) | Auto format khi lưu, Xem lỗi diagnostics | `conform.nvim`, `trouble.nvim`, `ts_ls` |
| [`test_navigation.py`](file:///etc/nixos/tests/test_navigation.py) | Quản lý file dạng text, Nhảy nhanh | `oil.nvim`, `flash.nvim`, `telescope` |

---

## ⌨️ Bảng phím tắt cần thử

### 1. ⚡ Auto-completion (`blink.cmp`)
* `gõ chữ`: Menu gợi ý tự động hiện ra với độ trễ 0ms.
* `<Tab>`: Chọn gợi ý tiếp theo (hoặc nhảy tới placeholder tiếp theo trong snippet).
* `<S-Tab>`: Chọn gợi ý phía trước.
* `<CR>` (Enter): Chấp nhận gợi ý đã chọn.
* `<C-Space>`: Mở / Đóng menu gợi ý và documentation.
* `<C-b>` / `<C-f>`: Cuộn tài liệu hướng dẫn của hàm lên / xuống.

### 2. 📁 Quản trị file (`oil.nvim`)
* `-` hoặc `<C-n>`: Mở thư mục hiện tại trong Oil.
  * **Đổi tên file:** Di chuyển con trỏ vào tên file, sửa như sửa text (`cw`), sau đó gõ `:w` để lưu!
  * **Tạo file mới:** Gõ `o` tạo dòng mới, nhập tên file rồi gõ `:w`.
  * **Xoá file:** Gõ `dd` xoá dòng của file đó rồi gõ `:w`.
  * `<CR>`: Mở file / thư mục đang chọn.
  * `<C-s>` / `<C-h>`: Mở file trong split dọc / ngang.

### 3. 🎨 Định dạng code (`conform.nvim`)
* `:w`: Tự động format toàn bộ file trước khi lưu.
* `<leader>lf` (Phím Space + l + f): Format thủ công file hiện tại.

### 4. 🔍 Chẩn đoán lỗi (`trouble.nvim`)
* `<leader>xx`: Bật / Tắt bảng tổng hợp lỗi toàn project.
* `<leader>xX`: Bật / Tắt bảng lỗi chỉ trong file đang mở.
* `<leader>cs`: Xem cây biểu tượng (Symbols: functions, classes, variables) trong file.

### 5. ⚡ Di chuyển nhanh (`flash.nvim`)
* `<leader>j`: Nhảy nhanh tới bất kỳ từ nào trên màn hình (gõ `<leader>j` rồi gõ 2 ký tự đầu của từ muốn đến).

### 6. 🔎 Tìm kiếm (`telescope.nvim`)
* `<C-p>`: Tìm file trong project.
* `<leader>fg`: Tìm kiếm nội dung văn bản (Live Grep).
* `<leader>fb`: Xem danh sách buffer đang mở.
