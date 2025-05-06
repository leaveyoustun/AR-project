# MATLAB Augmented‑Reality Demo – Virtual Cube Overlay

Reconstruct a camera’s projection matrix, then draw a 3‑D cube that stays glued to a coloured marker in a video.

<p align="center">
  <img src="result.gif" width="480" alt="Result preview">
</p>



## How it works

1. **Camera calibration** → intrinsic matrix **K** (MATLAB Camera Calibrator).  
2. Detect the four‑colour pattern in *IMG_0171.jpg* → compute homography **H**.  
3. Decompose **H** into rotation **R** and translation **T**; assemble **P = K [R | T]**.  
4. For every frame in *test_4couleur.mp4*:  
   * locate coloured disks (L*a*b threshold + `regionprops`)  
   * recover 3‑D pose, rebuild cube geometry  
   * project with **P** and draw edges.

---

