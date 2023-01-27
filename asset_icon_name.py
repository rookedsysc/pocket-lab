# 특정 폴더에 있는 파일이름 전부 출력
import os

folder_path = './asset/img/bank'

for filename in os.listdir(folder_path):
  # 은행 이름
  key = "\"" + filename.split("_")[2].split(".")[0] + "\""
  # 은행 파일 위치 
  value = "\"" + folder_path.split("./")[1] + "/" + filename + "\"," 

  print( key + ":" + value)