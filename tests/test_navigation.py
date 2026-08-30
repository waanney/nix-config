# ============================================================================
# 🧪 BÀI TEST 3: FILE MANAGER (OIL.NVIM) & FAST NAVIGATION (FLASH.NVIM)
# ============================================================================
# Mở file này bằng Neovim: nvim /etc/nixos/tests/test_navigation.py
# ============================================================================

# BƯỚC 1: TEST OIL.NVIM (QUẢN TRỊ FILE TRỰC TIẾP TRÊN TEXT BUFFER)
# Hướng dẫn:
# 1. Bấm phím `-` hoặc `<C-n>` (Ctrl + n).
#    -> Thư mục /etc/nixos/tests sẽ hiện ra dưới dạng một buffer text!
# 2. Thử đổi tên 1 file: Di chuyển con trỏ vào tên file, gõ `cw` để sửa tên, rồi gõ `:w` để áp dụng.
# 3. Bấm `-` lần nữa để đi lên thư mục cha (/etc/nixos).
# 4. Chọn 1 file và bấm `<CR>` để mở file đó, hoặc `<C-s>` để mở split dọc!

import os
import sys
from typing import List, Dict


# BƯỚC 2: TEST FLASH.NVIM (NHẢY CON TRỎ TỨC THÌ)
# Hướng dẫn:
# 1. Bấm phím `<leader>j` (Phím Space + j).
# 2. Nhập 2 chữ cái đầu của từ bạn muốn nhảy tới (Ví dụ: gõ `de` để nhảy tới `destination_target` bên dưới).
# 3. Bấm nhãn ký tự màu xuất hiện trên màn hình -> Con trỏ nhảy ngay lập tức tới đúng vị trí!

class NavigationDemo:
    def __init__(self, name: str):
        self.name = name
        self.data_store: Dict[str, List[int]] = {}

    def process_records(self, items: List[str]) -> bool:
        for item in items:
            print(f"Processing item: {item}")
        return True

    def destination_target(self) -> str:
        return f"Target reached: {self.name}!"


# BƯỚC 3: TEST TELESCOPE & LIVE GREP
# Hướng dẫn:
# 1. Bấm `<C-p>` (Ctrl + p) -> Gõ tên file để tìm kiếm nhanh.
# 2. Bấm `<leader>fg` (Space + f + g) -> Gõ từ khoá (vd: `NavigationDemo`) để tìm kiếm toàn project!
# 3. Bấm `<leader>fb` (Space + f + b) -> Xem và chuyển đổi giữa các file đang mở.
