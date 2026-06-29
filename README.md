# piper-gpu
criei um ambiente onde rodar o piper-tts 1.4.2 em gpu, é apenas o ambiente e como criar a imagem. não tem socat e nem gunicorn. veja a lista de dependencias. basta subir sua api no ambiente. L4, A100, RTX 4070 TI e RTX 6000 tiverem resultados incriveis numa api de teste. vou deixar o benchmark aqui.

faça o pull com docker pull bcdeosce/piper-gpu:base
se quiser testar no colabs, basta instalar as dependencias no colabs
pip install --no-cache-dir -r requirements.txt
depois deinstala o onnx-runtime cpu
pip uninstall -y onnxruntime onnxruntime-cpu 2>/dev/null
depois instala o onnx-gpu 
pip install --no-cache-dir --force-reinstall --no-deps onnxruntime-gpu==1.21.1
teste
python3 -c "\
import onnxruntime; \
print('Versão final:', onnxruntime.__version__); \
print('Providers:', onnxruntime.get_available_providers()); \
assert 'CUDAExecutionProvider' in onnxruntime.get_available_providers(), 'CUDA NÃO disponível!'"


