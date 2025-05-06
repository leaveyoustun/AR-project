**== DESCRIPTION ==**

* **Main\_ARCube.m** – Main script that overlays a virtual cube onto a test video.
  When you run it, MATLAB displays the result frame-by-frame, so playback looks choppy.
  A smoother version of the video is available one directory up.

* **matrice\_P.mat** – Contains the projection matrix **P** used by the main script.

* **homogene.m** – Helper function called by the main script; you don’t need to run it directly.

* **Calcul\_Matrice\_P.m** – Script we used to compute the projection matrix
  (**matrice\_P.mat**) from a reference image.

* **calibrationSessionPhoto.mat** – Camera-calibration data that lets us retrieve the intrinsic matrix **K**.

* **IMG\_0171.jpg** – Reference image used by *Calcul\_Matrice\_P.m*.

* **test\_4couleur.mp4** – Test video used by *Main\_ARCube.m*.
