# before running this, might need to: conda deactivate
gst-launch-1.0 -v tcpclientsrc host=10.0.0.2 port=5000 ! gdpdepay ! rtph264depay ! avdec_h264 ! autovideosink sync=false
