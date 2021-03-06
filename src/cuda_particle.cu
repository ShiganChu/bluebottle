/*******************************************************************************
 ******************************* BLUEBOTTLE-1.0 ********************************
 *******************************************************************************
 *
 *  Copyright 2012 - 2014 Adam Sierakowski, The Johns Hopkins University
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  Please contact the Johns Hopkins University to use Bluebottle for
 *  commercial and/or for-profit applications.
 ******************************************************************************/

#include "cuda_particle.h"

#include <cuda.h>
#include <helper_cuda.h>

extern "C"
void cuda_part_malloc(void)
{
  // allocate device memory on host
  _parts = (part_struct**) malloc(nsubdom * sizeof(part_struct*));
  cpumem += nsubdom * sizeof(part_struct*);
  _pnm_re = (real**) malloc(nsubdom * sizeof(real*));
  cpumem += nsubdom * sizeof(real*);
  _pnm_im = (real**) malloc(nsubdom * sizeof(real*));
  cpumem += nsubdom * sizeof(real*);
  _phinm_re = (real**) malloc(nsubdom * sizeof(real*));
  cpumem += nsubdom * sizeof(real*);
  _phinm_im = (real**) malloc(nsubdom * sizeof(real*));
  cpumem += nsubdom * sizeof(real*);
  _chinm_re = (real**) malloc(nsubdom * sizeof(real*));
  cpumem += nsubdom * sizeof(real*);
  _chinm_im = (real**) malloc(nsubdom * sizeof(real*));
  cpumem += nsubdom * sizeof(real*);
  _pnm_re0 = (real**) malloc(nsubdom * sizeof(real*));
  cpumem += nsubdom * sizeof(real*);
  _pnm_im0 = (real**) malloc(nsubdom * sizeof(real*));
  cpumem += nsubdom * sizeof(real*);
  _phinm_re0 = (real**) malloc(nsubdom * sizeof(real*));
  cpumem += nsubdom * sizeof(real*);
  _phinm_im0 = (real**) malloc(nsubdom * sizeof(real*));
  cpumem += nsubdom * sizeof(real*);
  _chinm_re0 = (real**) malloc(nsubdom * sizeof(real*));
  cpumem += nsubdom * sizeof(real*);
  _chinm_im0 = (real**) malloc(nsubdom * sizeof(real*));
  cpumem += nsubdom * sizeof(real*);
  _pnm_re00 = (real**) malloc(nsubdom * sizeof(real*));
  cpumem += nsubdom * sizeof(real*);
  _pnm_im00 = (real**) malloc(nsubdom * sizeof(real*));
  cpumem += nsubdom * sizeof(real*);
  _phinm_re00 = (real**) malloc(nsubdom * sizeof(real*));
  cpumem += nsubdom * sizeof(real*);
  _phinm_im00 = (real**) malloc(nsubdom * sizeof(real*));
  cpumem += nsubdom * sizeof(real*);
  _chinm_re00 = (real**) malloc(nsubdom * sizeof(real*));
  cpumem += nsubdom * sizeof(real*);
  _chinm_im00 = (real**) malloc(nsubdom * sizeof(real*));
  cpumem += nsubdom * sizeof(real*);

  _phase = (int**) malloc(nsubdom * sizeof(int*));
  cpumem += nsubdom * sizeof(int);
  _phase_shell = (int**) malloc(nsubdom * sizeof(int*));
  cpumem += nsubdom * sizeof(int);
  _flag_u = (int**) malloc(nsubdom * sizeof(int*));
  cpumem += nsubdom * sizeof(int);
  _flag_v = (int**) malloc(nsubdom * sizeof(int*));
  cpumem += nsubdom * sizeof(int);
  _flag_w = (int**) malloc(nsubdom * sizeof(int*));
  cpumem += nsubdom * sizeof(int);

  // allocate device memory on device
  #pragma omp parallel num_threads(nsubdom)
  {
    int dev = omp_get_thread_num();
    checkCudaErrors(cudaSetDevice(dev + dev_start));

    checkCudaErrors(cudaMalloc((void**) &(_parts[dev]),
      sizeof(part_struct) * nparts));
    gpumem += sizeof(part_struct) * nparts;

    checkCudaErrors(cudaMalloc((void**) &(_pnm_re[dev]),
      sizeof(real) * coeff_stride * nparts));
    gpumem += sizeof(real) * coeff_stride * nparts;
    checkCudaErrors(cudaMalloc((void**) &(_pnm_im[dev]),
      sizeof(real) * coeff_stride * nparts));
    gpumem += sizeof(real) * coeff_stride * nparts;
    checkCudaErrors(cudaMalloc((void**) &(_phinm_re[dev]),
      sizeof(real) * coeff_stride * nparts));
    gpumem += sizeof(real) * coeff_stride * nparts;
    checkCudaErrors(cudaMalloc((void**) &(_phinm_im[dev]),
      sizeof(real) * coeff_stride * nparts));
    gpumem += sizeof(real) * coeff_stride * nparts;
    checkCudaErrors(cudaMalloc((void**) &(_chinm_re[dev]),
      sizeof(real) * coeff_stride * nparts));
    gpumem += sizeof(real) * coeff_stride * nparts;
    checkCudaErrors(cudaMalloc((void**) &(_chinm_im[dev]),
      sizeof(real) * coeff_stride * nparts));
    gpumem += sizeof(real) * coeff_stride * nparts;

    checkCudaErrors(cudaMalloc((void**) &(_pnm_re0[dev]),
      sizeof(real) * coeff_stride * nparts));
    gpumem += sizeof(real) * coeff_stride * nparts;
    checkCudaErrors(cudaMalloc((void**) &(_pnm_im0[dev]),
      sizeof(real) * coeff_stride * nparts));
    gpumem += sizeof(real) * coeff_stride * nparts;
    checkCudaErrors(cudaMalloc((void**) &(_phinm_re0[dev]),
      sizeof(real) * coeff_stride * nparts));
    gpumem += sizeof(real) * coeff_stride * nparts;
    checkCudaErrors(cudaMalloc((void**) &(_phinm_im0[dev]),
      sizeof(real) * coeff_stride * nparts));
    gpumem += sizeof(real) * coeff_stride * nparts;
    checkCudaErrors(cudaMalloc((void**) &(_chinm_re0[dev]),
      sizeof(real) * coeff_stride * nparts));
    gpumem += sizeof(real) * coeff_stride * nparts;
    checkCudaErrors(cudaMalloc((void**) &(_chinm_im0[dev]),
      sizeof(real) * coeff_stride * nparts));
    gpumem += sizeof(real) * coeff_stride * nparts;

    checkCudaErrors(cudaMalloc((void**) &(_pnm_re00[dev]),
      sizeof(real) * coeff_stride * nparts));
    gpumem += sizeof(real) * coeff_stride * nparts;
    checkCudaErrors(cudaMalloc((void**) &(_pnm_im00[dev]),
      sizeof(real) * coeff_stride * nparts));
    gpumem += sizeof(real) * coeff_stride * nparts;
    checkCudaErrors(cudaMalloc((void**) &(_phinm_re00[dev]),
      sizeof(real) * coeff_stride * nparts));
    gpumem += sizeof(real) * coeff_stride * nparts;
    checkCudaErrors(cudaMalloc((void**) &(_phinm_im00[dev]),
      sizeof(real) * coeff_stride * nparts));
    gpumem += sizeof(real) * coeff_stride * nparts;
    checkCudaErrors(cudaMalloc((void**) &(_chinm_re00[dev]),
      sizeof(real) * coeff_stride * nparts));
    gpumem += sizeof(real) * coeff_stride * nparts;
    checkCudaErrors(cudaMalloc((void**) &(_chinm_im00[dev]),
      sizeof(real) * coeff_stride * nparts));
    gpumem += sizeof(real) * coeff_stride * nparts;

    checkCudaErrors(cudaMalloc((void**) &(_phase[dev]),
      sizeof(int) * dom[dev].Gcc.s3b));
    gpumem += sizeof(int) * dom[dev].Gcc.s3b;
    checkCudaErrors(cudaMalloc((void**) &(_phase_shell[dev]),
      sizeof(int) * dom[dev].Gcc.s3b));
    gpumem += sizeof(int) * dom[dev].Gcc.s3b;
    checkCudaErrors(cudaMalloc((void**) &(_flag_u[dev]),
      sizeof(int) * dom[dev].Gfx.s3b));
    gpumem += sizeof(int) * dom[dev].Gfx.s3b;
    checkCudaErrors(cudaMalloc((void**) &(_flag_v[dev]),
      sizeof(int) * dom[dev].Gfy.s3b));
    gpumem += sizeof(int) * dom[dev].Gfy.s3b;
    checkCudaErrors(cudaMalloc((void**) &(_flag_w[dev]),
      sizeof(int) * dom[dev].Gfz.s3b));
    gpumem += sizeof(int) * dom[dev].Gfz.s3b;
  }
}

extern "C"
void cuda_part_push(void)
{
  // copy host data to device
  #pragma omp parallel num_threads(nsubdom)
  {
    int dev = omp_get_thread_num();
    checkCudaErrors(cudaSetDevice(dev + dev_start));

    checkCudaErrors(cudaMemcpy(_parts[dev], parts, sizeof(part_struct) * nparts,
      cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_pnm_re[dev], pnm_re, sizeof(real) * coeff_stride
      * nparts, cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_pnm_im[dev], pnm_im, sizeof(real) * coeff_stride
      * nparts, cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_phinm_re[dev], phinm_re, sizeof(real)
      * coeff_stride * nparts, cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_phinm_im[dev], phinm_im, sizeof(real)
      * coeff_stride * nparts, cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_chinm_re[dev], chinm_re, sizeof(real)
      * coeff_stride * nparts, cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_chinm_im[dev], chinm_im, sizeof(real)
      * coeff_stride * nparts, cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_pnm_re0[dev], pnm_re0, sizeof(real)
      * coeff_stride * nparts, cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_pnm_im0[dev], pnm_im0, sizeof(real)
      * coeff_stride * nparts, cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_phinm_re0[dev], phinm_re0, sizeof(real)
      * coeff_stride * nparts, cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_phinm_im0[dev], phinm_im0, sizeof(real)
      * coeff_stride * nparts, cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_chinm_re0[dev], chinm_re0, sizeof(real)
      * coeff_stride * nparts, cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_chinm_im0[dev], chinm_im0, sizeof(real)
      * coeff_stride * nparts, cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_pnm_re00[dev], pnm_re00, sizeof(real)
      * coeff_stride * nparts, cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_pnm_im00[dev], pnm_im00, sizeof(real)
      * coeff_stride * nparts, cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_phinm_re00[dev], phinm_re00, sizeof(real)
      * coeff_stride * nparts, cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_phinm_im00[dev], phinm_im00, sizeof(real)
      * coeff_stride * nparts, cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_chinm_re00[dev], chinm_re00, sizeof(real)
      * coeff_stride * nparts, cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_chinm_im00[dev], chinm_im00, sizeof(real)
      * coeff_stride * nparts, cudaMemcpyHostToDevice));

    checkCudaErrors(cudaMemcpy(_phase[0], phase, sizeof(int) * dom[0].Gcc.s3b,
      cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_phase_shell[0], phase_shell,
      sizeof(int) * dom[0].Gcc.s3b, cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_flag_u[0], flag_u, sizeof(int) * dom[0].Gfx.s3b,
      cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_flag_v[0], flag_v, sizeof(int) * dom[0].Gfy.s3b,
      cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(_flag_w[0], flag_w, sizeof(int) * dom[0].Gfz.s3b,
      cudaMemcpyHostToDevice));
  }
}

extern "C"
void cuda_part_pull(void)
{
  // all devices have the same particle data for now, so just copy one of them
  checkCudaErrors(cudaMemcpy(parts, _parts[0], sizeof(part_struct) * nparts,
    cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(pnm_re, _pnm_re[0], sizeof(real) * coeff_stride
    * nparts,cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(pnm_im, _pnm_im[0], sizeof(real) * coeff_stride
    * nparts, cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(phinm_re, _phinm_re[0], sizeof(real) * coeff_stride
    * nparts, cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(phinm_im, _phinm_im[0], sizeof(real) * coeff_stride
    * nparts, cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(chinm_re, _chinm_re[0], sizeof(real) * coeff_stride
    * nparts, cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(chinm_im, _chinm_im[0], sizeof(real) * coeff_stride
    * nparts, cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(pnm_re0, _pnm_re0[0], sizeof(real) * coeff_stride
    * nparts,cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(pnm_im0, _pnm_im0[0], sizeof(real) * coeff_stride
    * nparts, cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(phinm_re0, _phinm_re0[0], sizeof(real) * coeff_stride
    * nparts, cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(phinm_im0, _phinm_im0[0], sizeof(real) * coeff_stride
    * nparts, cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(chinm_re0, _chinm_re0[0], sizeof(real) * coeff_stride
    * nparts, cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(chinm_im0, _chinm_im0[0], sizeof(real) * coeff_stride
    * nparts, cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(pnm_re00, _pnm_re00[0], sizeof(real) * coeff_stride
    * nparts,cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(pnm_im00, _pnm_im00[0], sizeof(real) * coeff_stride
    * nparts, cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(phinm_re00, _phinm_re00[0], sizeof(real) * coeff_stride
    * nparts, cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(phinm_im00, _phinm_im00[0], sizeof(real) * coeff_stride
    * nparts, cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(chinm_re00, _chinm_re00[0], sizeof(real) * coeff_stride
    * nparts, cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(chinm_im00, _chinm_im00[0], sizeof(real) * coeff_stride
    * nparts, cudaMemcpyDeviceToHost));

  // copy for device cage setup testing
  checkCudaErrors(cudaMemcpy(phase, _phase[0], sizeof(int) * dom[0].Gcc.s3b,
    cudaMemcpyDeviceToHost));

#ifdef DEBUG
  checkCudaErrors(cudaMemcpy(phase_shell, _phase_shell[0],
    sizeof(int) * dom[0].Gcc.s3b, cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(flag_u, _flag_u[0], sizeof(int) * dom[0].Gfx.s3b,
    cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(flag_v, _flag_v[0], sizeof(int) * dom[0].Gfy.s3b,
    cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaMemcpy(flag_w, _flag_w[0], sizeof(int) * dom[0].Gfz.s3b,
    cudaMemcpyDeviceToHost));
#endif
}

extern "C"
void cuda_part_free(void)
{
  // free device memory on device
  #pragma omp parallel num_threads(nsubdom)
  {
    int dev = omp_get_thread_num();
    checkCudaErrors(cudaSetDevice(dev + dev_start));

    checkCudaErrors(cudaFree(_parts[dev]));
    checkCudaErrors(cudaFree(_pnm_re[dev]));
    checkCudaErrors(cudaFree(_pnm_im[dev]));
    checkCudaErrors(cudaFree(_phinm_re[dev]));
    checkCudaErrors(cudaFree(_phinm_im[dev]));
    checkCudaErrors(cudaFree(_chinm_re[dev]));
    checkCudaErrors(cudaFree(_chinm_im[dev]));
    checkCudaErrors(cudaFree(_pnm_re0[dev]));
    checkCudaErrors(cudaFree(_pnm_im0[dev]));
    checkCudaErrors(cudaFree(_phinm_re0[dev]));
    checkCudaErrors(cudaFree(_phinm_im0[dev]));
    checkCudaErrors(cudaFree(_chinm_re0[dev]));
    checkCudaErrors(cudaFree(_chinm_im0[dev]));
    checkCudaErrors(cudaFree(_pnm_re00[dev]));
    checkCudaErrors(cudaFree(_pnm_im00[dev]));
    checkCudaErrors(cudaFree(_phinm_re00[dev]));
    checkCudaErrors(cudaFree(_phinm_im00[dev]));
    checkCudaErrors(cudaFree(_chinm_re00[dev]));
    checkCudaErrors(cudaFree(_chinm_im00[dev]));
    checkCudaErrors(cudaFree(_phase[dev]));
    checkCudaErrors(cudaFree(_phase_shell[dev]));
    checkCudaErrors(cudaFree(_flag_u[dev]));
    checkCudaErrors(cudaFree(_flag_v[dev]));
    checkCudaErrors(cudaFree(_flag_w[dev]));
  }

  free(_parts);
  free(_pnm_re);
  free(_pnm_im);
  free(_phinm_re);
  free(_phinm_im);
  free(_chinm_re);
  free(_chinm_im);
  free(_pnm_re0);
  free(_pnm_im0);
  free(_phinm_re0);
  free(_phinm_im0);
  free(_chinm_re0);
  free(_chinm_im0);
  free(_pnm_re00);
  free(_pnm_im00);
  free(_phinm_re00);
  free(_phinm_im00);
  free(_chinm_re00);
  free(_chinm_im00);
  free(_phase);
  free(_phase_shell);
  free(_flag_u);
  free(_flag_v);
  free(_flag_w);
}

extern "C"
void cuda_build_cages(void)
{
  cuda_part_pull();

  // parallelize over domains
  #pragma omp parallel num_threads(nsubdom)
  {
    int dev = omp_get_thread_num();
    checkCudaErrors(cudaSetDevice(dev + dev_start));

    int i;    // iterator
    real Y, Z;  // virtual particle center location

    int threads_x = 0;
    int threads_y = 0;
    int threads_z = 0;
    int blocks_x = 0;
    int blocks_y = 0;
    int blocks_z = 0;

    int threads_c = 0; // number of threads for cage build

    // reset phase
    if(dom[dev].Gcc.jnb < MAX_THREADS_DIM)
      threads_y = dom[dev].Gcc.jnb;
    else
      threads_y = MAX_THREADS_DIM;

    if(dom[dev].Gcc.knb < MAX_THREADS_DIM)
      threads_z = dom[dev].Gcc.knb;
    else
      threads_z = MAX_THREADS_DIM;

    blocks_y = (int)ceil((real) dom[dev].Gcc.jnb / (real) threads_y);
    blocks_z = (int)ceil((real) dom[dev].Gcc.knb / (real) threads_z);

    dim3 dimBlocks(threads_y, threads_z);
    dim3 numBlocks(blocks_y, blocks_z);

    reset_phase<<<numBlocks, dimBlocks>>>(_phase[dev], _dom[dev]);
    reset_phase_shell<<<numBlocks, dimBlocks>>>(_phase_shell[dev], _dom[dev]);

    // reset flag_u
    if(dom[dev].Gfx.jn < MAX_THREADS_DIM)
      threads_y = dom[dev].Gfx.jnb;
    else
      threads_y = MAX_THREADS_DIM;

    if(dom[dev].Gfx.kn < MAX_THREADS_DIM)
      threads_z = dom[dev].Gfx.knb;
    else
      threads_z = MAX_THREADS_DIM;

    blocks_y = (int)ceil((real) dom[dev].Gfx.jnb / (real) threads_y);
    blocks_z = (int)ceil((real) dom[dev].Gfx.knb / (real) threads_z);

    dim3 dimBlocks_u(threads_y, threads_z);
    dim3 numBlocks_u(blocks_y, blocks_z);

    reset_flag_u<<<numBlocks_u, dimBlocks_u>>>(_flag_u[dev], _dom[dev], bc);

    // reset flag_v
    if(dom[dev].Gfy.kn < MAX_THREADS_DIM)
      threads_z = dom[dev].Gfy.knb;
    else
      threads_z = MAX_THREADS_DIM;

    if(dom[dev].Gfy.in < MAX_THREADS_DIM)
      threads_x = dom[dev].Gfy.inb;
    else
      threads_x = MAX_THREADS_DIM;

    blocks_z = (int)ceil((real) dom[dev].Gfy.knb / (real) threads_z);
    blocks_x = (int)ceil((real) dom[dev].Gfy.inb / (real) threads_x);

    dim3 dimBlocks_v(threads_z, threads_x);
    dim3 numBlocks_v(blocks_z, blocks_x);

    reset_flag_v<<<numBlocks_v, dimBlocks_v>>>(_flag_v[dev], _dom[dev], bc);

    // reset flag_w
    if(dom[dev].Gfz.in < MAX_THREADS_DIM)
      threads_x = dom[dev].Gfz.inb;
    else
      threads_x = MAX_THREADS_DIM;

    if(dom[dev].Gfz.jn < MAX_THREADS_DIM)
      threads_y = dom[dev].Gfz.jnb;
    else
      threads_y = MAX_THREADS_DIM;

    blocks_x = (int)ceil((real) dom[dev].Gfz.inb / (real) threads_x);
    blocks_y = (int)ceil((real) dom[dev].Gfz.jnb / (real) threads_y);

    dim3 dimBlocks_w(threads_x, threads_y);
    dim3 numBlocks_w(blocks_x, blocks_y);

    reset_flag_w<<<numBlocks_w, dimBlocks_w>>>(_flag_w[dev], _dom[dev], bc);

    // build cages and update phase
    // TODO: do the first half of this on the card
    threads_c = MAX_THREADS_DIM;
    for(i = 0; i < nparts; i++) {
      // set up cage extents
      // add 4 cells to ensure cage is completely contained in the bounding box
      parts[i].cage.in = (int)(2.0 * ceil(parts[i].r / dom[dev].dx));// + 2;
      parts[i].cage.jn = (int)(2.0 * ceil(parts[i].r / dom[dev].dy));// + 2;
      parts[i].cage.kn = (int)(2.0 * ceil(parts[i].r / dom[dev].dz));// + 2;

      // remove a cell from cage for odd number of cells in domain
      if(dom[dev].xn % 2) {
        parts[i].cage.in = parts[i].cage.in - 1;
      }
      if(dom[dev].yn % 2) {
        parts[i].cage.jn = parts[i].cage.jn - 1;
      }
      if(dom[dev].zn % 2) {
        parts[i].cage.kn = parts[i].cage.kn - 1;
      }

      // find indices of cell that contains the particle center
      parts[i].cage.cx = (int)((parts[i].x - dom->xs + 0.5 * dom->dx) / dom->dx);
      parts[i].cage.cy = (int)((parts[i].y - dom->ys + 0.5 * dom->dy) / dom->dy);
      parts[i].cage.cz = (int)((parts[i].z - dom->zs + 0.5 * dom->dz) / dom->dz);

      // compute start and end cells of cage that contains particle
      parts[i].cage.is = (int)(round((parts[i].x-dom->xs)/dom->dx)
        - 0.5 * parts[i].cage.in + DOM_BUF);
      parts[i].cage.ie = parts[i].cage.is + parts[i].cage.in;
      if(parts[i].cage.is <= dom->Gcc.is) {
        parts[i].cage.is = parts[i].cage.is + dom->Gcc.ie;
        parts[i].cage.ibs = dom->Gcc.ie;
        parts[i].cage.ibe = dom->Gcc.is;
      } else if(parts[i].cage.ie > dom->Gcc.ie) {
        parts[i].cage.ie = parts[i].cage.ie - dom->Gcc.ie;
        parts[i].cage.ibs = dom->Gcc.ie;
        parts[i].cage.ibe = dom->Gcc.is;
      } else {
        parts[i].cage.ibs = parts[i].cage.ie;
        parts[i].cage.ibe = parts[i].cage.ie;
      }

      parts[i].cage.js = (int)(round((parts[i].y-dom->ys)/dom->dy)
        - 0.5 * parts[i].cage.jn + DOM_BUF);
      parts[i].cage.je = parts[i].cage.js + parts[i].cage.jn;
      if(parts[i].cage.js <= dom->Gcc.js) {
        parts[i].cage.js = parts[i].cage.js + dom->Gcc.je;
        parts[i].cage.jbs = dom->Gcc.je;
        parts[i].cage.jbe = dom->Gcc.js;
      } else if(parts[i].cage.je > dom->Gcc.je) {
        parts[i].cage.je = parts[i].cage.je - dom->Gcc.je;
        parts[i].cage.jbs = dom->Gcc.je;
        parts[i].cage.jbe = dom->Gcc.js;
      } else {
        parts[i].cage.jbs = parts[i].cage.je;
        parts[i].cage.jbe = parts[i].cage.je;
      }

      parts[i].cage.ks = (int)(round((parts[i].z-dom->zs)/dom->dz)
        - 0.5 * parts[i].cage.kn + DOM_BUF);
      parts[i].cage.ke = parts[i].cage.ks + parts[i].cage.kn;
      if(parts[i].cage.ks <= dom->Gcc.ks) {
        parts[i].cage.ks = parts[i].cage.ks + dom->Gcc.ke;
        parts[i].cage.kbs = dom->Gcc.ke;
        parts[i].cage.kbe = dom->Gcc.ks;
      } else if(parts[i].cage.ke > dom->Gcc.ke) {
        parts[i].cage.ke = parts[i].cage.ke - dom->Gcc.ke;
        parts[i].cage.kbs = dom->Gcc.ke;
        parts[i].cage.kbe = dom->Gcc.ks;
      } else {
        parts[i].cage.kbs = parts[i].cage.ke;
        parts[i].cage.kbe = parts[i].cage.ke;
      }

    }

    // push particle information to device
    checkCudaErrors(cudaMemcpy(_parts[dev], parts, sizeof(part_struct) * nparts,
      cudaMemcpyHostToDevice));

    for(i = 0; i < nparts; i++) {
      // BS quadrant
      blocks_x = (int)ceil((real) parts[i].cage.in / (real) threads_c);
      blocks_y = (int)ceil((real) (parts[i].cage.jbs - parts[i].cage.js)
        / (real) threads_c);
      blocks_z = (int)ceil((real) (parts[i].cage.kbs - parts[i].cage.ks)
        / (real) threads_c);

      dim3 dimBlocks_c(threads_c, threads_c);
      dim3 numBlocks_c(blocks_y, blocks_z);

      if(parts[i].y < (dom[dev].ys + parts[i].r)) Y = parts[i].y + dom[dev].yl;
      else Y = parts[i].y;
      if(parts[i].z < (dom[dev].zs + parts[i].r)) Z = parts[i].z + dom[dev].zl;
      else Z = parts[i].z;

      if(blocks_y > 0 && blocks_z > 0)
        build_cage<<<numBlocks_c, dimBlocks_c>>>(i, _parts[dev],
          _phase[dev], _phase_shell[dev], _dom[dev],
          Y, Z,
          parts[i].cage.js, parts[i].cage.jbs,
          parts[i].cage.ks, parts[i].cage.kbs);

      // BN quadrant
      blocks_x = (int)ceil((real) parts[i].cage.in / (real) threads_c);
      blocks_y = (int)ceil((real) (parts[i].cage.je - (parts[i].cage.jbe))
        / (real) threads_c);
      blocks_z = (int)ceil((real) (parts[i].cage.kbs - parts[i].cage.ks)
        / (real) threads_c);

      numBlocks_c.x = blocks_y;
      numBlocks_c.y = blocks_z;

      if(parts[i].y > (dom[dev].ye - parts[i].r)) Y = parts[i].y - dom[dev].yl;
      else Y = parts[i].y;
      if(parts[i].z < (dom[dev].zs + parts[i].r)) Z = parts[i].z + dom[dev].zl;
      else Z = parts[i].z;

      if(blocks_y > 0 && blocks_z > 0)
        build_cage<<<numBlocks_c, dimBlocks_c>>>(i, _parts[dev],
          _phase[dev], _phase_shell[dev], _dom[dev],
          Y, Z,
          parts[i].cage.jbe, parts[i].cage.je,
          parts[i].cage.ks, parts[i].cage.kbs);

      // TS quadrant
      blocks_x = (int)ceil((real) parts[i].cage.in / (real) threads_c);
      blocks_y = (int)ceil((real) (parts[i].cage.jbs - parts[i].cage.js)
        / (real) threads_c);
      blocks_z = (int)ceil((real) (parts[i].cage.ke - (parts[i].cage.kbe))
        / (real) threads_c);

      numBlocks_c.x = blocks_y;
      numBlocks_c.y = blocks_z;

      if(parts[i].y < (dom[dev].ys + parts[i].r)) Y = parts[i].y + dom[dev].yl;
      else Y = parts[i].y;
      if(parts[i].z > (dom[dev].ze - parts[i].r)) Z = parts[i].z - dom[dev].zl;
      else Z = parts[i].z;

      if(blocks_y > 0 && blocks_z > 0)
        build_cage<<<numBlocks_c, dimBlocks_c>>>(i, _parts[dev],
          _phase[dev], _phase_shell[dev], _dom[dev],
          Y, Z,
          parts[i].cage.js, parts[i].cage.jbs,
          parts[i].cage.kbe, parts[i].cage.ke);

      // TN quadrant
      blocks_x = (int)ceil((real) parts[i].cage.in / (real) threads_c);
      blocks_y = (int)ceil((real) (parts[i].cage.je - (parts[i].cage.jbe))
        / (real) threads_c);
      blocks_z = (int)ceil((real) (parts[i].cage.ke - (parts[i].cage.kbe))
        / (real) threads_c);

      numBlocks_c.x = blocks_y;
      numBlocks_c.y = blocks_z;

      if(parts[i].y > (dom[dev].ye - parts[i].r)) Y = parts[i].y - dom[dev].yl;
      else Y = parts[i].y;
      if(parts[i].z > (dom[dev].ze - parts[i].r)) Z = parts[i].z - dom[dev].zl;
      else Z = parts[i].z;

      if(blocks_y > 0 && blocks_z > 0)
        build_cage<<<numBlocks_c, dimBlocks_c>>>(i, _parts[dev],
          _phase[dev], _phase_shell[dev], _dom[dev],
          Y, Z,
          parts[i].cage.jbe, parts[i].cage.je,
          parts[i].cage.kbe, parts[i].cage.ke);

      // fill in ghost cells for periodic boundary conditions
      if(bc.uW == PERIODIC) {
        blocks_y = (int)ceil((real) dom[dev].Gcc.jnb / (real) threads_y);
        blocks_z = (int)ceil((real) dom[dev].Gcc.knb / (real) threads_z);
        numBlocks_c.x = blocks_y;
        numBlocks_c.y = blocks_z;
        cage_phases_periodic_W<<<numBlocks_c, dimBlocks_c>>>(_phase[dev],
          _phase_shell[dev], _dom[dev]);
      }
      if(bc.uE == PERIODIC) {
        blocks_y = (int)ceil((real) dom[dev].Gcc.jnb / (real) threads_y);
        blocks_z = (int)ceil((real) dom[dev].Gcc.knb / (real) threads_z);
        numBlocks_c.x = blocks_y;
        numBlocks_c.y = blocks_z;
        cage_phases_periodic_E<<<numBlocks_c, dimBlocks_c>>>(_phase[dev],
          _phase_shell[dev], _dom[dev]);
      }
      if(bc.vS == PERIODIC) {
        blocks_z = (int)ceil((real) dom[dev].Gcc.knb / (real) threads_z);
        blocks_x = (int)ceil((real) dom[dev].Gcc.inb / (real) threads_x);
        numBlocks_c.x = blocks_z;
        numBlocks_c.y = blocks_x;
        cage_phases_periodic_S<<<numBlocks_c, dimBlocks_c>>>(_phase[dev],
          _phase_shell[dev], _dom[dev]);
      }
      if(bc.vN == PERIODIC) {
        blocks_z = (int)ceil((real) dom[dev].Gcc.knb / (real) threads_z);
        blocks_x = (int)ceil((real) dom[dev].Gcc.inb / (real) threads_x);
        numBlocks_c.x = blocks_z;
        numBlocks_c.y = blocks_x;
        cage_phases_periodic_N<<<numBlocks_c, dimBlocks_c>>>(_phase[dev],
          _phase_shell[dev], _dom[dev]);
      }
      if(bc.wB == PERIODIC) {
        blocks_x = (int)ceil((real) dom[dev].Gcc.inb / (real) threads_x);
        blocks_y = (int)ceil((real) dom[dev].Gcc.jnb / (real) threads_y);
        numBlocks_c.x = blocks_x;
        numBlocks_c.y = blocks_y;
        cage_phases_periodic_B<<<numBlocks_c, dimBlocks_c>>>(_phase[dev],
          _phase_shell[dev], _dom[dev]);
      }
      if(bc.wT == PERIODIC) {
        blocks_x = (int)ceil((real) dom[dev].Gcc.inb / (real) threads_x);
        blocks_y = (int)ceil((real) dom[dev].Gcc.jnb / (real) threads_y);
        numBlocks_c.x = blocks_x;
        numBlocks_c.y = blocks_y;
        cage_phases_periodic_T<<<numBlocks_c, dimBlocks_c>>>(_phase[dev],
          _phase_shell[dev], _dom[dev]);
      }

      // do flagging

      threads_x = MAX_THREADS_DIM;
      threads_y = MAX_THREADS_DIM;
      threads_z = MAX_THREADS_DIM;

      // u
      // BS quadrant
      blocks_x = (int)ceil((real) parts[i].cage.in / (real) threads_x);
      blocks_y = (int)ceil((real) (parts[i].cage.jbs - parts[i].cage.js)
        / (real) threads_y);
      blocks_z = (int)ceil((real) (parts[i].cage.kbs - parts[i].cage.ks)
        / (real) threads_z);

      dim3 dimBlocks_cu(threads_y, threads_z);
      dim3 numBlocks_cu(blocks_y, blocks_z);

      if(blocks_y > 0 && blocks_z > 0)
        cage_flag_u_1<<<numBlocks_cu, dimBlocks_cu>>>(i, _flag_u[dev],
          _parts[dev], _dom[dev], _phase[dev], _phase_shell[dev],
          parts[i].cage.js, parts[i].cage.jbs,
          parts[i].cage.ks, parts[i].cage.kbs);

      // BN quadrant
      blocks_x = (int)ceil((real) parts[i].cage.in / (real) threads_x);
      blocks_y = (int)ceil((real) (parts[i].cage.je - parts[i].cage.jbe)
        / (real) threads_y);
      blocks_z = (int)ceil((real) (parts[i].cage.kbs - parts[i].cage.ks)
        / (real) threads_z);

      numBlocks_cu.x = blocks_y;
      numBlocks_cu.y = blocks_z;

      if(blocks_y > 0 && blocks_z > 0)
        cage_flag_u_1<<<numBlocks_cu, dimBlocks_cu>>>(i, _flag_u[dev],
          _parts[dev], _dom[dev], _phase[dev], _phase_shell[dev],
          parts[i].cage.jbe, parts[i].cage.je,
          parts[i].cage.ks, parts[i].cage.kbs);

      // TS quadrant
      blocks_x = (int)ceil((real) parts[i].cage.in / (real) threads_x);
      blocks_y = (int)ceil((real) (parts[i].cage.jbs - parts[i].cage.js)
        / (real) threads_y);
      blocks_z = (int)ceil((real) (parts[i].cage.ke - parts[i].cage.kbe)
        / (real) threads_z);

      numBlocks_cu.x = blocks_y;
      numBlocks_cu.y = blocks_z;

      if(blocks_y > 0 && blocks_z > 0)
        cage_flag_u_1<<<numBlocks_cu, dimBlocks_cu>>>(i, _flag_u[dev],
          _parts[dev], _dom[dev], _phase[dev], _phase_shell[dev],
          parts[i].cage.js, parts[i].cage.jbs,
          parts[i].cage.kbe, parts[i].cage.ke);

      // TN quadrant
      blocks_x = (int)ceil((real) parts[i].cage.in / (real) threads_x);
      blocks_y = (int)ceil((real) (parts[i].cage.je - parts[i].cage.jbe)
        / (real) threads_y);
      blocks_z = (int)ceil((real) (parts[i].cage.ke - parts[i].cage.kbe)
        / (real) threads_z);

      numBlocks_cu.x = blocks_y;
      numBlocks_cu.y = blocks_z;

      if(blocks_y > 0 && blocks_z > 0)
        cage_flag_u_1<<<numBlocks_cu, dimBlocks_cu>>>(i, _flag_u[dev],
          _parts[dev], _dom[dev], _phase[dev], _phase_shell[dev],
          parts[i].cage.jbe, parts[i].cage.je,
          parts[i].cage.kbe, parts[i].cage.ke);

      // v
      // BW quadrant
      blocks_x = (int)ceil((real) (parts[i].cage.ibs - parts[i].cage.is)
        / (real) threads_x);
      blocks_y = (int)ceil((real) parts[i].cage.jn / (real) threads_y);
      blocks_z = (int)ceil((real) (parts[i].cage.kbs - parts[i].cage.ks)
        / (real) threads_z);

      dim3 dimBlocks_cv(threads_z, threads_x);
      dim3 numBlocks_cv(blocks_z, blocks_x);

      if(blocks_x > 0 && blocks_z > 0)
        cage_flag_v_1<<<numBlocks_cv, dimBlocks_cv>>>(i, _flag_v[dev],
          _parts[dev], _dom[dev], _phase[dev], _phase_shell[dev],
          parts[i].cage.is, parts[i].cage.ibs,
          parts[i].cage.ks, parts[i].cage.kbs);

      // BE quadrant
      blocks_x = (int)ceil((real) (parts[i].cage.ie - parts[i].cage.ibe)
        / (real) threads_x);
      blocks_y = (int)ceil((real) parts[i].cage.jn / (real) threads_y);
      blocks_z = (int)ceil((real) (parts[i].cage.kbs - parts[i].cage.ks)
        / (real) threads_z);

      numBlocks_cv.x = blocks_z;
      numBlocks_cv.y = blocks_x;

      if(blocks_x > 0 && blocks_z > 0)
        cage_flag_v_1<<<numBlocks_cv, dimBlocks_cv>>>(i, _flag_v[dev],
          _parts[dev], _dom[dev], _phase[dev], _phase_shell[dev],
          parts[i].cage.ibe, parts[i].cage.ie,
          parts[i].cage.ks, parts[i].cage.kbs);

      // TW quadrant
      blocks_x = (int)ceil((real) (parts[i].cage.ibs - parts[i].cage.is)
        / (real) threads_x);
      blocks_y = (int)ceil((real) parts[i].cage.jn / (real) threads_y);
      blocks_z = (int)ceil((real) (parts[i].cage.ke - parts[i].cage.kbe)
        / (real) threads_z);

      numBlocks_cv.x = blocks_z;
      numBlocks_cv.y = blocks_x;

      if(blocks_x > 0 && blocks_z > 0)
        cage_flag_v_1<<<numBlocks_cv, dimBlocks_cv>>>(i, _flag_v[dev],
          _parts[dev], _dom[dev], _phase[dev], _phase_shell[dev],
          parts[i].cage.is, parts[i].cage.ibs,
          parts[i].cage.kbe, parts[i].cage.ke);

      // TE quadrant
      blocks_x = (int)ceil((real) (parts[i].cage.ie - parts[i].cage.ibe)
        / (real) threads_x);
      blocks_y = (int)ceil((real) parts[i].cage.jn / (real) threads_y);
      blocks_z = (int)ceil((real) (parts[i].cage.ke - parts[i].cage.kbe)
        / (real) threads_z);

      numBlocks_cv.x = blocks_z;
      numBlocks_cv.y = blocks_x;

      if(blocks_x > 0 && blocks_z > 0)
        cage_flag_v_1<<<numBlocks_cv, dimBlocks_cv>>>(i, _flag_v[dev],
          _parts[dev], _dom[dev], _phase[dev], _phase_shell[dev],
          parts[i].cage.ibe, parts[i].cage.ie,
          parts[i].cage.kbe, parts[i].cage.ke);

      // w
      // SW quadrant
      blocks_x = (int)ceil((real) (parts[i].cage.ibs - parts[i].cage.is)
        / (real) threads_x);
      blocks_y = (int)ceil((real) (parts[i].cage.jbs - parts[i].cage.js)
        / (real) threads_y);
      blocks_z = (int)ceil((real) parts[i].cage.kn / (real) threads_z);

      dim3 dimBlocks_cw(threads_x, threads_y);
      dim3 numBlocks_cw(blocks_x, blocks_y);

      if(blocks_x > 0 && blocks_y > 0)
        cage_flag_w_1<<<numBlocks_cw, dimBlocks_cw>>>(i, _flag_w[dev],
          _parts[dev],  _dom[dev], _phase[dev], _phase_shell[dev],
          parts[i].cage.is, parts[i].cage.ibs,
          parts[i].cage.js, parts[i].cage.jbs);

      // SE quadrant
      blocks_x = (int)ceil((real) (parts[i].cage.ie - parts[i].cage.ibe)
        / (real) threads_x);
      blocks_y = (int)ceil((real) (parts[i].cage.jbs - parts[i].cage.js)
        / (real) threads_y);
      blocks_z = (int)ceil((real) parts[i].cage.kn / (real) threads_z);

      numBlocks_cw.x = blocks_x;
      numBlocks_cw.y = blocks_y;

      if(blocks_x > 0 && blocks_y > 0)
        cage_flag_w_1<<<numBlocks_cw, dimBlocks_cw>>>(i, _flag_w[dev],
          _parts[dev], _dom[dev], _phase[dev], _phase_shell[dev],
          parts[i].cage.ibe, parts[i].cage.ie,
          parts[i].cage.js, parts[i].cage.jbs);

      // NW quadrant
      blocks_x = (int)ceil((real) (parts[i].cage.ibs - parts[i].cage.is)
        / (real) threads_x);
      blocks_y = (int)ceil((real) (parts[i].cage.je - parts[i].cage.jbe)
        / (real) threads_y);
      blocks_z = (int)ceil((real) parts[i].cage.kn / (real) threads_z);

      numBlocks_cw.x = blocks_x;
      numBlocks_cw.y = blocks_y;

      if(blocks_x > 0 && blocks_y > 0)
        cage_flag_w_1<<<numBlocks_cw, dimBlocks_cw>>>(i, _flag_w[dev],
          _parts[dev], _dom[dev], _phase[dev], _phase_shell[dev],
          parts[i].cage.is, parts[i].cage.ibs,
          parts[i].cage.jbe, parts[i].cage.je);

      // NE quadrant
      blocks_x = (int)ceil((real) (parts[i].cage.ie - parts[i].cage.ibe)
        / (real) threads_x);
      blocks_y = (int)ceil((real) (parts[i].cage.je - parts[i].cage.jbe)
        / (real) threads_y);
      blocks_z = (int)ceil((real) parts[i].cage.kn / (real) threads_z);

      numBlocks_cw.x = blocks_x;
      numBlocks_cw.y = blocks_y;

      if(blocks_x > 0 && blocks_y > 0)
        cage_flag_w_1<<<numBlocks_cw, dimBlocks_cw>>>(i, _flag_w[dev],
          _parts[dev], _dom[dev], _phase[dev], _phase_shell[dev],
          parts[i].cage.ibe, parts[i].cage.ie,
          parts[i].cage.jbe, parts[i].cage.je);

      // fill in ghost cells for periodic boundary conditions
      if(bc.uW == PERIODIC) {
        blocks_y = (int)ceil((real) dom[dev].Gcc.jnb / (real) threads_y);
        blocks_z = (int)ceil((real) dom[dev].Gcc.knb / (real) threads_z);
        numBlocks_c.x = blocks_y;
        numBlocks_c.y = blocks_z;
        cage_phases_periodic_W<<<numBlocks_c, dimBlocks_c>>>(_phase[dev],
          _phase_shell[dev], _dom[dev]);
      }
      if(bc.uE == PERIODIC) {
        blocks_y = (int)ceil((real) dom[dev].Gcc.jnb / (real) threads_y);
        blocks_z = (int)ceil((real) dom[dev].Gcc.knb / (real) threads_z);
        numBlocks_c.x = blocks_y;
        numBlocks_c.y = blocks_z;
        cage_phases_periodic_E<<<numBlocks_c, dimBlocks_c>>>(_phase[dev],
          _phase_shell[dev], _dom[dev]);
      }
      if(bc.vS == PERIODIC) {
        blocks_z = (int)ceil((real) dom[dev].Gcc.knb / (real) threads_z);
        blocks_x = (int)ceil((real) dom[dev].Gcc.inb / (real) threads_x);
        numBlocks_c.x = blocks_z;
        numBlocks_c.y = blocks_x;
        cage_phases_periodic_S<<<numBlocks_c, dimBlocks_c>>>(_phase[dev],
          _phase_shell[dev], _dom[dev]);
      }
      if(bc.vN == PERIODIC) {
        blocks_z = (int)ceil((real) dom[dev].Gcc.knb / (real) threads_z);
        blocks_x = (int)ceil((real) dom[dev].Gcc.inb / (real) threads_x);
        numBlocks_c.x = blocks_z;
        numBlocks_c.y = blocks_x;
        cage_phases_periodic_N<<<numBlocks_c, dimBlocks_c>>>(_phase[dev],
          _phase_shell[dev], _dom[dev]);
      }
      if(bc.wB == PERIODIC) {
        blocks_x = (int)ceil((real) dom[dev].Gcc.inb / (real) threads_x);
        blocks_y = (int)ceil((real) dom[dev].Gcc.jnb / (real) threads_y);
        numBlocks_c.x = blocks_x;
        numBlocks_c.y = blocks_y;
        cage_phases_periodic_B<<<numBlocks_c, dimBlocks_c>>>(_phase[dev],
          _phase_shell[dev], _dom[dev]);
      }
      if(bc.wT == PERIODIC) {
        blocks_x = (int)ceil((real) dom[dev].Gcc.inb / (real) threads_x);
        blocks_y = (int)ceil((real) dom[dev].Gcc.jnb / (real) threads_y);
        numBlocks_c.x = blocks_x;
        numBlocks_c.y = blocks_y;
        cage_phases_periodic_T<<<numBlocks_c, dimBlocks_c>>>(_phase[dev],
          _phase_shell[dev], _dom[dev]);
      }

      // fill in ghost cells for periodic boundary conditions
      if(bc.uW == PERIODIC) {
        blocks_y = (int)ceil((real) dom[dev].Gfx.jnb / (real) threads_y);
        blocks_z = (int)ceil((real) dom[dev].Gfx.knb / (real) threads_z);
        numBlocks_cu.x = blocks_y;
        numBlocks_cu.y = blocks_z;
        cage_flag_u_periodic_W<<<numBlocks_cu, dimBlocks_cu>>>(_flag_u[dev],
          _dom[dev]);
      }
      if(bc.uE == PERIODIC) {
        blocks_y = (int)ceil((real) dom[dev].Gfx.jnb / (real) threads_y);
        blocks_z = (int)ceil((real) dom[dev].Gfx.knb / (real) threads_z);
        numBlocks_cu.x = blocks_y;
        numBlocks_cu.y = blocks_z;
        cage_flag_u_periodic_E<<<numBlocks_cu, dimBlocks_cu>>>(_flag_u[dev],
          _dom[dev]);
      }
      if(bc.uS == PERIODIC) {
        blocks_z = (int)ceil((real) dom[dev].Gfx.knb / (real) threads_z);
        blocks_x = (int)ceil((real) dom[dev].Gfx.inb / (real) threads_x);
        numBlocks_cu.x = blocks_z;
        numBlocks_cu.y = blocks_x;
        cage_flag_u_periodic_S<<<numBlocks_cu, dimBlocks_cu>>>(_flag_u[dev],
          _dom[dev]);
      }
      if(bc.uN == PERIODIC) {
        blocks_z = (int)ceil((real) dom[dev].Gfx.knb / (real) threads_z);
        blocks_x = (int)ceil((real) dom[dev].Gfx.inb / (real) threads_x);
        numBlocks_cu.x = blocks_z;
        numBlocks_cu.y = blocks_x;
        cage_flag_u_periodic_N<<<numBlocks_cu, dimBlocks_cu>>>(_flag_u[dev],
          _dom[dev]);
      }
      if(bc.uB == PERIODIC) {
        blocks_x = (int)ceil((real) dom[dev].Gfx.inb / (real) threads_x);
        blocks_y = (int)ceil((real) dom[dev].Gfx.jnb / (real) threads_y);
        numBlocks_cu.x = blocks_x;
        numBlocks_cu.y = blocks_y;
        cage_flag_u_periodic_B<<<numBlocks_cu, dimBlocks_cu>>>(_flag_u[dev],
          _dom[dev]);
      }
      if(bc.uT == PERIODIC) {
        blocks_x = (int)ceil((real) dom[dev].Gfx.inb / (real) threads_x);
        blocks_y = (int)ceil((real) dom[dev].Gfx.jnb / (real) threads_y);
        numBlocks_cu.x = blocks_x;
        numBlocks_cu.y = blocks_y;
        cage_flag_u_periodic_T<<<numBlocks_cu, dimBlocks_cu>>>(_flag_u[dev],
          _dom[dev]);
      }

      if(bc.vW == PERIODIC) {
        blocks_y = (int)ceil((real) dom[dev].Gfy.jnb / (real) threads_y);
        blocks_z = (int)ceil((real) dom[dev].Gfy.knb / (real) threads_z);
        numBlocks_cv.x = blocks_y;
        numBlocks_cv.y = blocks_z;
        cage_flag_v_periodic_W<<<numBlocks_cv, dimBlocks_cv>>>(_flag_v[dev],
          _dom[dev]);
      }
      if(bc.vE == PERIODIC) {
        blocks_y = (int)ceil((real) dom[dev].Gfy.jnb / (real) threads_y);
        blocks_z = (int)ceil((real) dom[dev].Gfy.knb / (real) threads_z);
        numBlocks_cv.x = blocks_y;
        numBlocks_cv.y = blocks_z;
        cage_flag_v_periodic_E<<<numBlocks_cv, dimBlocks_cv>>>(_flag_v[dev],
          _dom[dev]);
      }
      if(bc.vS == PERIODIC) {
        blocks_z = (int)ceil((real) dom[dev].Gfy.knb / (real) threads_z);
        blocks_x = (int)ceil((real) dom[dev].Gfy.inb / (real) threads_x);
        numBlocks_cv.x = blocks_z;
        numBlocks_cv.y = blocks_x;
        cage_flag_v_periodic_S<<<numBlocks_cv, dimBlocks_cv>>>(_flag_v[dev],
          _dom[dev]);
      }
      if(bc.vN == PERIODIC) {
        blocks_z = (int)ceil((real) dom[dev].Gfy.knb / (real) threads_z);
        blocks_x = (int)ceil((real) dom[dev].Gfy.inb / (real) threads_x);
        numBlocks_cv.x = blocks_z;
        numBlocks_cv.y = blocks_x;
        cage_flag_v_periodic_N<<<numBlocks_cv, dimBlocks_cv>>>(_flag_v[dev],
          _dom[dev]);
      }
      if(bc.vB == PERIODIC) {
        blocks_x = (int)ceil((real) dom[dev].Gfy.inb / (real) threads_x);
        blocks_y = (int)ceil((real) dom[dev].Gfy.jnb / (real) threads_y);
        numBlocks_cv.x = blocks_x;
        numBlocks_cv.y = blocks_y;
        cage_flag_v_periodic_B<<<numBlocks_cv, dimBlocks_cv>>>(_flag_v[dev],
          _dom[dev]);
      }
      if(bc.vT == PERIODIC) {
        blocks_x = (int)ceil((real) dom[dev].Gfy.inb / (real) threads_x);
        blocks_y = (int)ceil((real) dom[dev].Gfy.jnb / (real) threads_y);
        numBlocks_cv.x = blocks_x;
        numBlocks_cv.y = blocks_y;
        cage_flag_v_periodic_T<<<numBlocks_cv, dimBlocks_cv>>>(_flag_v[dev],
          _dom[dev]);
      }

      if(bc.wW == PERIODIC) {
        blocks_y = (int)ceil((real) dom[dev].Gfz.jnb / (real) threads_y);
        blocks_z = (int)ceil((real) dom[dev].Gfz.knb / (real) threads_z);
        numBlocks_cw.x = blocks_y;
        numBlocks_cw.y = blocks_z;
        cage_flag_w_periodic_W<<<numBlocks_cw, dimBlocks_cw>>>(_flag_w[dev],
          _dom[dev]);
      }
      if(bc.wE == PERIODIC) {
        blocks_y = (int)ceil((real) dom[dev].Gfz.jnb / (real) threads_y);
        blocks_z = (int)ceil((real) dom[dev].Gfz.knb / (real) threads_z);
        numBlocks_cw.x = blocks_y;
        numBlocks_cw.y = blocks_z;
        cage_flag_w_periodic_E<<<numBlocks_cw, dimBlocks_cw>>>(_flag_w[dev],
          _dom[dev]);
      }
      if(bc.wS == PERIODIC) {
        blocks_z = (int)ceil((real) dom[dev].Gfz.knb / (real) threads_z);
        blocks_x = (int)ceil((real) dom[dev].Gfz.inb / (real) threads_x);
        numBlocks_cw.x = blocks_z;
        numBlocks_cw.y = blocks_x;
        cage_flag_w_periodic_S<<<numBlocks_cw, dimBlocks_cw>>>(_flag_w[dev],
          _dom[dev]);
      }
      if(bc.wN == PERIODIC) {
        blocks_z = (int)ceil((real) dom[dev].Gfz.knb / (real) threads_z);
        blocks_x = (int)ceil((real) dom[dev].Gfz.inb / (real) threads_x);
        numBlocks_cw.x = blocks_z;
        numBlocks_cw.y = blocks_x;
        cage_flag_w_periodic_N<<<numBlocks_cw, dimBlocks_cw>>>(_flag_w[dev],
          _dom[dev]);
      }
      if(bc.wB == PERIODIC) {
        blocks_x = (int)ceil((real) dom[dev].Gfz.inb / (real) threads_x);
        blocks_y = (int)ceil((real) dom[dev].Gfz.jnb / (real) threads_y);
        numBlocks_cw.x = blocks_x;
        numBlocks_cw.y = blocks_y;
        cage_flag_w_periodic_B<<<numBlocks_cw, dimBlocks_cw>>>(_flag_w[dev],
          _dom[dev]);
      }
      if(bc.wT == PERIODIC) {
        blocks_x = (int)ceil((real) dom[dev].Gfz.inb / (real) threads_x);
        blocks_y = (int)ceil((real) dom[dev].Gfz.jnb / (real) threads_y);
        numBlocks_cw.x = blocks_x;
        numBlocks_cw.y = blocks_y;
        cage_flag_w_periodic_T<<<numBlocks_cw, dimBlocks_cw>>>(_flag_w[dev],
          _dom[dev]);
      }

      // create a copy of the flags for this step so intermediate flags don't
      // corrupt algorithm

      int *_flag_u_tmp;
      int *_flag_v_tmp;
      int *_flag_w_tmp;
      checkCudaErrors(cudaMalloc((void**) &(_flag_u_tmp),
        sizeof(int) * dom[dev].Gfx.s3b));
      gpumem += sizeof(int) * dom[dev].Gfx.s3b;
      checkCudaErrors(cudaMalloc((void**) &(_flag_v_tmp),
        sizeof(int) * dom[dev].Gfy.s3b));
      gpumem += sizeof(int) * dom[dev].Gfy.s3b;
      checkCudaErrors(cudaMalloc((void**) &(_flag_w_tmp),
        sizeof(int) * dom[dev].Gfz.s3b));
      gpumem += sizeof(int) * dom[dev].Gfz.s3b;
      checkCudaErrors(cudaMemcpy(_flag_u_tmp, _flag_u[dev],
        sizeof(int) * dom[dev].Gfx.s3b, cudaMemcpyDeviceToDevice));
      checkCudaErrors(cudaMemcpy(_flag_v_tmp, _flag_v[dev],
        sizeof(int) * dom[dev].Gfy.s3b, cudaMemcpyDeviceToDevice));
      checkCudaErrors(cudaMemcpy(_flag_w_tmp, _flag_w[dev],
        sizeof(int) * dom[dev].Gfz.s3b, cudaMemcpyDeviceToDevice));

      // u
      // BS quadrant
      blocks_x = (int)ceil((real) parts[i].cage.in / (real) threads_x);
      blocks_y = (int)ceil((real) (parts[i].cage.jbs - parts[i].cage.js)
        / (real) threads_y);
      blocks_z = (int)ceil((real) (parts[i].cage.kbs - parts[i].cage.ks)
        / (real) threads_z);

      numBlocks_cu.x = blocks_y;
      numBlocks_cu.y = blocks_z;

      if(blocks_y > 0 && blocks_z > 0)
        cage_flag_u_2<<<numBlocks_cu, dimBlocks_cu>>>(i, _flag_u_tmp,
          _flag_v[dev], _flag_w[dev],
          _parts[dev], _dom[dev], _phase[dev],
          parts[i].cage.js, parts[i].cage.jbs,
          parts[i].cage.ks, parts[i].cage.kbs);

      // BN quadrant
      blocks_x = (int)ceil((real) parts[i].cage.in / (real) threads_x);
      blocks_y = (int)ceil((real) (parts[i].cage.je - parts[i].cage.jbe)
        / (real) threads_y);
      blocks_z = (int)ceil((real) (parts[i].cage.kbs - parts[i].cage.ks)
        / (real) threads_z);

      numBlocks_cu.x = blocks_y;
      numBlocks_cu.y = blocks_z;

      if(blocks_y > 0 && blocks_z > 0)
        cage_flag_u_2<<<numBlocks_cu, dimBlocks_cu>>>(i, _flag_u_tmp,
          _flag_v[dev], _flag_w[dev],
          _parts[dev], _dom[dev], _phase[dev],
          parts[i].cage.jbe, parts[i].cage.je,
          parts[i].cage.ks, parts[i].cage.kbs);

      // TS quadrant
      blocks_x = (int)ceil((real) parts[i].cage.in / (real) threads_x);
      blocks_y = (int)ceil((real) (parts[i].cage.jbs - parts[i].cage.js)
        / (real) threads_y);
      blocks_z = (int)ceil((real) (parts[i].cage.ke - parts[i].cage.kbe)
        / (real) threads_z);

      numBlocks_cu.x = blocks_y;
      numBlocks_cu.y = blocks_z;

      if(blocks_y > 0 && blocks_z > 0)
        cage_flag_u_2<<<numBlocks_cu, dimBlocks_cu>>>(i, _flag_u_tmp,
          _flag_v[dev], _flag_w[dev],
          _parts[dev], _dom[dev], _phase[dev],
          parts[i].cage.js, parts[i].cage.jbs,
          parts[i].cage.kbe, parts[i].cage.ke);

      // TN quadrant
      blocks_x = (int)ceil((real) parts[i].cage.in / (real) threads_x);
      blocks_y = (int)ceil((real) (parts[i].cage.je - parts[i].cage.jbe)
        / (real) threads_y);
      blocks_z = (int)ceil((real) (parts[i].cage.ke - parts[i].cage.kbe)
        / (real) threads_z);

      numBlocks_cu.x = blocks_y;
      numBlocks_cu.y = blocks_z;

      if(blocks_y > 0 && blocks_z > 0)
        cage_flag_u_2<<<numBlocks_cu, dimBlocks_cu>>>(i, _flag_u_tmp,
          _flag_v[dev], _flag_w[dev],
          _parts[dev], _dom[dev], _phase[dev],
          parts[i].cage.jbe, parts[i].cage.je,
          parts[i].cage.kbe, parts[i].cage.ke);

      // v
      // BW quadrant
      blocks_x = (int)ceil((real) (parts[i].cage.ibs - parts[i].cage.is)
        / (real) threads_x);
      blocks_y = (int)ceil((real) parts[i].cage.jn / (real) threads_y);
      blocks_z = (int)ceil((real) (parts[i].cage.kbs - parts[i].cage.ks)
        / (real) threads_z);

      numBlocks_cv.x = blocks_z;
      numBlocks_cv.y = blocks_x;

      if(blocks_x > 0 && blocks_z > 0)
        cage_flag_v_2<<<numBlocks_cv, dimBlocks_cv>>>(i, _flag_u[dev],
          _flag_v_tmp, _flag_w[dev],
          _parts[dev], _dom[dev], _phase[dev],
          parts[i].cage.is, parts[i].cage.ibs,
          parts[i].cage.ks, parts[i].cage.kbs);

      // BE quadrant
      blocks_x = (int)ceil((real) (parts[i].cage.ie - parts[i].cage.ibe)
        / (real) threads_x);
      blocks_y = (int)ceil((real) parts[i].cage.jn / (real) threads_y);
      blocks_z = (int)ceil((real) (parts[i].cage.kbs - parts[i].cage.ks)
        / (real) threads_z);

      numBlocks_cv.x = blocks_z;
      numBlocks_cv.y = blocks_x;

      if(blocks_x > 0 && blocks_z > 0)
        cage_flag_v_2<<<numBlocks_cv, dimBlocks_cv>>>(i, _flag_u[dev],
          _flag_v_tmp, _flag_w[dev],
          _parts[dev], _dom[dev], _phase[dev],
          parts[i].cage.ibe, parts[i].cage.ie,
          parts[i].cage.ks, parts[i].cage.kbs);

      // TW quadrant
      blocks_x = (int)ceil((real) (parts[i].cage.ibs - parts[i].cage.is)
        / (real) threads_x);
      blocks_y = (int)ceil((real) parts[i].cage.jn / (real) threads_y);
      blocks_z = (int)ceil((real) (parts[i].cage.ke - parts[i].cage.kbe)
        / (real) threads_z);

      numBlocks_cv.x = blocks_z;
      numBlocks_cv.y = blocks_x;

      if(blocks_x > 0 && blocks_z > 0)
        cage_flag_v_2<<<numBlocks_cv, dimBlocks_cv>>>(i, _flag_u[dev],
          _flag_v_tmp, _flag_w[dev],
          _parts[dev], _dom[dev], _phase[dev],
          parts[i].cage.is, parts[i].cage.ibs,
          parts[i].cage.kbe, parts[i].cage.ke);

      // TE quadrant
      blocks_x = (int)ceil((real) (parts[i].cage.ie - parts[i].cage.ibe)
        / (real) threads_x);
      blocks_y = (int)ceil((real) parts[i].cage.jn / (real) threads_y);
      blocks_z = (int)ceil((real) (parts[i].cage.ke - parts[i].cage.kbe)
        / (real) threads_z);

      numBlocks_cv.x = blocks_z;
      numBlocks_cv.y = blocks_x;

      if(blocks_x > 0 && blocks_z > 0)
        cage_flag_v_2<<<numBlocks_cv, dimBlocks_cv>>>(i, _flag_u[dev],
          _flag_v_tmp, _flag_w[dev],
          _parts[dev], _dom[dev], _phase[dev],
          parts[i].cage.ibe, parts[i].cage.ie,
          parts[i].cage.kbe, parts[i].cage.ke);

      // w
      // SW quadrant
      blocks_x = (int)ceil((real) (parts[i].cage.ibs - parts[i].cage.is)
        / (real) threads_x);
      blocks_y = (int)ceil((real) (parts[i].cage.jbs - parts[i].cage.js)
        / (real) threads_y);
      blocks_z = (int)ceil((real) parts[i].cage.kn / (real) threads_z);

      numBlocks_cw.x = blocks_x;
      numBlocks_cw.y = blocks_y;

      if(blocks_x > 0 && blocks_y > 0)
        cage_flag_w_2<<<numBlocks_cw, dimBlocks_cw>>>(i, _flag_u[dev],
          _flag_v[dev], _flag_w_tmp,
          _parts[dev],  _dom[dev], _phase[dev],
          parts[i].cage.is, parts[i].cage.ibs,
          parts[i].cage.js, parts[i].cage.jbs);

      // SE quadrant
      blocks_x = (int)ceil((real) (parts[i].cage.ie - parts[i].cage.ibe)
        / (real) threads_x);
      blocks_y = (int)ceil((real) (parts[i].cage.jbs - parts[i].cage.js)
        / (real) threads_y);
      blocks_z = (int)ceil((real) parts[i].cage.kn / (real) threads_z);

      numBlocks_cw.x = blocks_x;
      numBlocks_cw.y = blocks_y;

      if(blocks_x > 0 && blocks_y > 0)
        cage_flag_w_2<<<numBlocks_cw, dimBlocks_cw>>>(i, _flag_u[dev],
          _flag_v[dev], _flag_w_tmp,
          _parts[dev], _dom[dev], _phase[dev],
          parts[i].cage.ibe, parts[i].cage.ie,
          parts[i].cage.js, parts[i].cage.jbs);

      // NW quadrant
      blocks_x = (int)ceil((real) (parts[i].cage.ibs - parts[i].cage.is)
        / (real) threads_x);
      blocks_y = (int)ceil((real) (parts[i].cage.je - parts[i].cage.jbe)
        / (real) threads_y);
      blocks_z = (int)ceil((real) parts[i].cage.kn / (real) threads_z);

      numBlocks_cw.x = blocks_x;
      numBlocks_cw.y = blocks_y;

      if(blocks_x > 0 && blocks_y > 0)
        cage_flag_w_2<<<numBlocks_cw, dimBlocks_cw>>>(i, _flag_u[dev],
          _flag_v[dev], _flag_w_tmp,
          _parts[dev], _dom[dev], _phase[dev],
          parts[i].cage.is, parts[i].cage.ibs,
          parts[i].cage.jbe, parts[i].cage.je);

      // NE quadrant
      blocks_x = (int)ceil((real) (parts[i].cage.ie - parts[i].cage.ibe)
        / (real) threads_x);
      blocks_y = (int)ceil((real) (parts[i].cage.je - parts[i].cage.jbe)
        / (real) threads_y);
      blocks_z = (int)ceil((real) parts[i].cage.kn / (real) threads_z);

      numBlocks_cw.x = blocks_x;
      numBlocks_cw.y = blocks_y;

      if(blocks_x > 0 && blocks_y > 0)
        cage_flag_w_2<<<numBlocks_cw, dimBlocks_cw>>>(i, _flag_u[dev],
          _flag_v[dev], _flag_w_tmp,
          _parts[dev], _dom[dev], _phase[dev],
          parts[i].cage.ibe, parts[i].cage.ie,
          parts[i].cage.jbe, parts[i].cage.je);

      // now copy the results back

      checkCudaErrors(cudaMemcpy(_flag_u[dev], _flag_u_tmp,
        sizeof(int) * dom[dev].Gfx.s3b, cudaMemcpyDeviceToDevice));
      checkCudaErrors(cudaMemcpy(_flag_v[dev], _flag_v_tmp,
        sizeof(int) * dom[dev].Gfy.s3b, cudaMemcpyDeviceToDevice));
      checkCudaErrors(cudaMemcpy(_flag_w[dev], _flag_w_tmp,
        sizeof(int) * dom[dev].Gfz.s3b, cudaMemcpyDeviceToDevice));

      // clean up copies
      checkCudaErrors(cudaFree(_flag_u_tmp));
      checkCudaErrors(cudaFree(_flag_v_tmp));
      checkCudaErrors(cudaFree(_flag_w_tmp));

      // fill in ghost cells for periodic boundary conditions
      if(bc.uW == PERIODIC) {
        blocks_y = (int)ceil((real) dom[dev].Gfx.jnb / (real) threads_y);
        blocks_z = (int)ceil((real) dom[dev].Gfx.knb / (real) threads_z);
        numBlocks_cu.x = blocks_y;
        numBlocks_cu.y = blocks_z;
        cage_flag_u_periodic_W<<<numBlocks_cu, dimBlocks_cu>>>(_flag_u[dev],
          _dom[dev]);
      }
      if(bc.uE == PERIODIC) {
        blocks_y = (int)ceil((real) dom[dev].Gfx.jnb / (real) threads_y);
        blocks_z = (int)ceil((real) dom[dev].Gfx.knb / (real) threads_z);
        numBlocks_cu.x = blocks_y;
        numBlocks_cu.y = blocks_z;
        cage_flag_u_periodic_E<<<numBlocks_cu, dimBlocks_cu>>>(_flag_u[dev],
          _dom[dev]);
      }
      if(bc.uS == PERIODIC) {
        blocks_z = (int)ceil((real) dom[dev].Gfx.knb / (real) threads_z);
        blocks_x = (int)ceil((real) dom[dev].Gfx.inb / (real) threads_x);
        numBlocks_cu.x = blocks_z;
        numBlocks_cu.y = blocks_x;
        cage_flag_u_periodic_S<<<numBlocks_cu, dimBlocks_cu>>>(_flag_u[dev],
          _dom[dev]);
      }
      if(bc.uN == PERIODIC) {
        blocks_z = (int)ceil((real) dom[dev].Gfx.knb / (real) threads_z);
        blocks_x = (int)ceil((real) dom[dev].Gfx.inb / (real) threads_x);
        numBlocks_cu.x = blocks_z;
        numBlocks_cu.y = blocks_x;
        cage_flag_u_periodic_N<<<numBlocks_cu, dimBlocks_cu>>>(_flag_u[dev],
          _dom[dev]);
      }
      if(bc.uB == PERIODIC) {
        blocks_x = (int)ceil((real) dom[dev].Gfx.inb / (real) threads_x);
        blocks_y = (int)ceil((real) dom[dev].Gfx.jnb / (real) threads_y);
        numBlocks_cu.x = blocks_x;
        numBlocks_cu.y = blocks_y;
        cage_flag_u_periodic_B<<<numBlocks_cu, dimBlocks_cu>>>(_flag_u[dev],
          _dom[dev]);
      }
      if(bc.uT == PERIODIC) {
        blocks_x = (int)ceil((real) dom[dev].Gfx.inb / (real) threads_x);
        blocks_y = (int)ceil((real) dom[dev].Gfx.jnb / (real) threads_y);
        numBlocks_cu.x = blocks_x;
        numBlocks_cu.y = blocks_y;
        cage_flag_u_periodic_T<<<numBlocks_cu, dimBlocks_cu>>>(_flag_u[dev],
          _dom[dev]);
      }

      if(bc.vW == PERIODIC) {
        blocks_y = (int)ceil((real) dom[dev].Gfy.jnb / (real) threads_y);
        blocks_z = (int)ceil((real) dom[dev].Gfy.knb / (real) threads_z);
        numBlocks_cv.x = blocks_y;
        numBlocks_cv.y = blocks_z;
        cage_flag_v_periodic_W<<<numBlocks_cv, dimBlocks_cv>>>(_flag_v[dev],
          _dom[dev]);
      }
      if(bc.vE == PERIODIC) {
        blocks_y = (int)ceil((real) dom[dev].Gfy.jnb / (real) threads_y);
        blocks_z = (int)ceil((real) dom[dev].Gfy.knb / (real) threads_z);
        numBlocks_cv.x = blocks_y;
        numBlocks_cv.y = blocks_z;
        cage_flag_v_periodic_E<<<numBlocks_cv, dimBlocks_cv>>>(_flag_v[dev],
          _dom[dev]);
      }
      if(bc.vS == PERIODIC) {
        blocks_z = (int)ceil((real) dom[dev].Gfy.knb / (real) threads_z);
        blocks_x = (int)ceil((real) dom[dev].Gfy.inb / (real) threads_x);
        numBlocks_cv.x = blocks_z;
        numBlocks_cv.y = blocks_x;
        cage_flag_v_periodic_S<<<numBlocks_cv, dimBlocks_cv>>>(_flag_v[dev],
          _dom[dev]);
      }
      if(bc.vN == PERIODIC) {
        blocks_z = (int)ceil((real) dom[dev].Gfy.knb / (real) threads_z);
        blocks_x = (int)ceil((real) dom[dev].Gfy.inb / (real) threads_x);
        numBlocks_cv.x = blocks_z;
        numBlocks_cv.y = blocks_x;
        cage_flag_v_periodic_N<<<numBlocks_cv, dimBlocks_cv>>>(_flag_v[dev],
          _dom[dev]);
      }
      if(bc.vB == PERIODIC) {
        blocks_x = (int)ceil((real) dom[dev].Gfy.inb / (real) threads_x);
        blocks_y = (int)ceil((real) dom[dev].Gfy.jnb / (real) threads_y);
        numBlocks_cv.x = blocks_x;
        numBlocks_cv.y = blocks_y;
        cage_flag_v_periodic_B<<<numBlocks_cv, dimBlocks_cv>>>(_flag_v[dev],
          _dom[dev]);
      }
      if(bc.vT == PERIODIC) {
        blocks_x = (int)ceil((real) dom[dev].Gfy.inb / (real) threads_x);
        blocks_y = (int)ceil((real) dom[dev].Gfy.jnb / (real) threads_y);
        numBlocks_cv.x = blocks_x;
        numBlocks_cv.y = blocks_y;
        cage_flag_v_periodic_T<<<numBlocks_cv, dimBlocks_cv>>>(_flag_v[dev],
          _dom[dev]);
      }

      if(bc.wW == PERIODIC) {
        blocks_y = (int)ceil((real) dom[dev].Gfz.jnb / (real) threads_y);
        blocks_z = (int)ceil((real) dom[dev].Gfz.knb / (real) threads_z);
        numBlocks_cw.x = blocks_y;
        numBlocks_cw.y = blocks_z;
        cage_flag_w_periodic_W<<<numBlocks_cw, dimBlocks_cw>>>(_flag_w[dev],
          _dom[dev]);
      }
      if(bc.wE == PERIODIC) {
        blocks_y = (int)ceil((real) dom[dev].Gfz.jnb / (real) threads_y);
        blocks_z = (int)ceil((real) dom[dev].Gfz.knb / (real) threads_z);
        numBlocks_cw.x = blocks_y;
        numBlocks_cw.y = blocks_z;
        cage_flag_w_periodic_E<<<numBlocks_cw, dimBlocks_cw>>>(_flag_w[dev],
          _dom[dev]);
      }
      if(bc.wS == PERIODIC) {
        blocks_z = (int)ceil((real) dom[dev].Gfz.knb / (real) threads_z);
        blocks_x = (int)ceil((real) dom[dev].Gfz.inb / (real) threads_x);
        numBlocks_cw.x = blocks_z;
        numBlocks_cw.y = blocks_x;
        cage_flag_w_periodic_S<<<numBlocks_cw, dimBlocks_cw>>>(_flag_w[dev],
          _dom[dev]);
      }
      if(bc.wN == PERIODIC) {
        blocks_z = (int)ceil((real) dom[dev].Gfz.knb / (real) threads_z);
        blocks_x = (int)ceil((real) dom[dev].Gfz.inb / (real) threads_x);
        numBlocks_cw.x = blocks_z;
        numBlocks_cw.y = blocks_x;
        cage_flag_w_periodic_N<<<numBlocks_cw, dimBlocks_cw>>>(_flag_w[dev],
          _dom[dev]);
      }
      if(bc.wB == PERIODIC) {
        blocks_x = (int)ceil((real) dom[dev].Gfz.inb / (real) threads_x);
        blocks_y = (int)ceil((real) dom[dev].Gfz.jnb / (real) threads_y);
        numBlocks_cw.x = blocks_x;
        numBlocks_cw.y = blocks_y;
        cage_flag_w_periodic_B<<<numBlocks_cw, dimBlocks_cw>>>(_flag_w[dev],
          _dom[dev]);
      }
      if(bc.wT == PERIODIC) {
        blocks_x = (int)ceil((real) dom[dev].Gfz.inb / (real) threads_x);
        blocks_y = (int)ceil((real) dom[dev].Gfz.jnb / (real) threads_y);
        numBlocks_cw.x = blocks_x;
        numBlocks_cw.y = blocks_y;
        cage_flag_w_periodic_T<<<numBlocks_cw, dimBlocks_cw>>>(_flag_w[dev],
          _dom[dev]);
      }
    }
  }
}

extern "C"
void cuda_part_BC(void)
{
  // parallize across domains
  #pragma omp parallel num_threads(nsubdom)
  {
    int dev = omp_get_thread_num();
    checkCudaErrors(cudaSetDevice(dev + dev_start));

    int threads_x = MAX_THREADS_DIM;
    int threads_y = MAX_THREADS_DIM;
    int threads_z = MAX_THREADS_DIM;
    int blocks_x = 0;
    int blocks_y = 0;
    int blocks_z = 0;

    // u
    blocks_y = (int)ceil((real) dom[dev].Gfx.jnb / (real) threads_y);
    blocks_z = (int)ceil((real) dom[dev].Gfx.knb / (real) threads_z);
    dim3 dimBlocks_x(threads_y, threads_z);
    dim3 numBlocks_x(blocks_y, blocks_z);
    part_BC_u<<<numBlocks_x, dimBlocks_x>>>(_u[dev], _phase[dev],
      _flag_u[dev], _parts[dev], _dom[dev], nu, coeff_stride,
      _pnm_re[dev], _pnm_im[dev], _phinm_re[dev], _phinm_im[dev],
      _chinm_re[dev], _chinm_im[dev]);

    // v
    blocks_z = (int)ceil((real) dom[dev].Gfy.knb / (real) threads_z);
    blocks_x = (int)ceil((real) dom[dev].Gfy.inb / (real) threads_x);
    dim3 dimBlocks_y(threads_z, threads_x);
    dim3 numBlocks_y(blocks_z, blocks_x);
    part_BC_v<<<numBlocks_y, dimBlocks_y>>>(_v[dev], _phase[dev],
      _flag_v[dev], _parts[dev], _dom[dev], nu, coeff_stride,
      _pnm_re[dev], _pnm_im[dev], _phinm_re[dev], _phinm_im[dev],
      _chinm_re[dev], _chinm_im[dev]);

    // w
    blocks_x = (int)ceil((real) dom[dev].Gfz.inb / (real) threads_x);
    blocks_y = (int)ceil((real) dom[dev].Gfz.jnb / (real) threads_y);
    dim3 dimBlocks_z(threads_x, threads_y);
    dim3 numBlocks_z(blocks_x, blocks_y);
    part_BC_w<<<numBlocks_z, dimBlocks_z>>>(_w[dev], _phase[dev],
      _flag_w[dev], _parts[dev], _dom[dev], nu, coeff_stride,
      _pnm_re[dev], _pnm_im[dev], _phinm_re[dev], _phinm_im[dev],
      _chinm_re[dev], _chinm_im[dev]);
  }
}

extern "C"
void cuda_part_BC_star(void)
{
  // parallize across domains
  #pragma omp parallel num_threads(nsubdom)
  {
    int dev = omp_get_thread_num();
    checkCudaErrors(cudaSetDevice(dev + dev_start));

    int threads_x = MAX_THREADS_DIM;
    int threads_y = MAX_THREADS_DIM;
    int threads_z = MAX_THREADS_DIM;
    int blocks_x = 0;
    int blocks_y = 0;
    int blocks_z = 0;

    // u
    blocks_y = (int)ceil((real) dom[dev].Gfx.jnb / (real) threads_y);
    blocks_z = (int)ceil((real) dom[dev].Gfx.knb / (real) threads_z);
    dim3 dimBlocks_x(threads_y, threads_z);
    dim3 numBlocks_x(blocks_y, blocks_z);
    part_BC_u<<<numBlocks_x, dimBlocks_x>>>(_u_star[dev], _phase[dev],
      _flag_u[dev], _parts[dev], _dom[dev], nu, coeff_stride,
      _pnm_re[dev], _pnm_im[dev], _phinm_re[dev], _phinm_im[dev],
      _chinm_re[dev], _chinm_im[dev]);

    // v
    blocks_z = (int)ceil((real) dom[dev].Gfy.knb / (real) threads_z);
    blocks_x = (int)ceil((real) dom[dev].Gfy.inb / (real) threads_x);
    dim3 dimBlocks_y(threads_z, threads_x);
    dim3 numBlocks_y(blocks_z, blocks_x);
    part_BC_v<<<numBlocks_y, dimBlocks_y>>>(_v_star[dev], _phase[dev],
      _flag_v[dev], _parts[dev], _dom[dev], nu, coeff_stride,
      _pnm_re[dev], _pnm_im[dev], _phinm_re[dev], _phinm_im[dev],
      _chinm_re[dev], _chinm_im[dev]);

    // w
    blocks_x = (int)ceil((real) dom[dev].Gfz.inb / (real) threads_x);
    blocks_y = (int)ceil((real) dom[dev].Gfz.jnb / (real) threads_y);
    dim3 dimBlocks_z(threads_x, threads_y);
    dim3 numBlocks_z(blocks_x, blocks_y);
    part_BC_w<<<numBlocks_z, dimBlocks_z>>>(_w_star[dev], _phase[dev],
      _flag_w[dev], _parts[dev], _dom[dev], nu, coeff_stride,
      _pnm_re[dev], _pnm_im[dev], _phinm_re[dev], _phinm_im[dev],
      _chinm_re[dev], _chinm_im[dev]);
  }
}

// already CPU parallelized in cuda_PP_bicgstab, which calls it
extern "C"
void cuda_part_BC_p(int dev)
{
  int threads_c = MAX_THREADS_DIM;
  int blocks_y = 0;
  int blocks_z = 0;

  blocks_y = (int)ceil((real) dom[dev].Gcc.jn / (real) threads_c);
  blocks_z = (int)ceil((real) dom[dev].Gcc.kn / (real) threads_c);

  dim3 dimBlocks_c(threads_c, threads_c);
  dim3 numBlocks_c(blocks_y, blocks_z);

  part_BC_p<<<numBlocks_c, dimBlocks_c>>>(_p0[dev], _rhs_p[dev], _phase[dev],
    _phase_shell[dev], _parts[dev], _dom[dev],
    mu, nu, dt, gradP, rho_f, coeff_stride,
    _pnm_re00[dev], _pnm_im00[dev],
    _phinm_re00[dev], _phinm_im00[dev], _chinm_re00[dev], _chinm_im00[dev],
    _pnm_re[dev], _pnm_im[dev],
    _phinm_re[dev], _phinm_im[dev], _chinm_re[dev], _chinm_im[dev]);
}

extern "C"
void cuda_store_coeffs(void)
{
  // parallelize over CPU threads
  #pragma omp parallel num_threads(nsubdom)
  {
    int dev = omp_get_thread_num();
    checkCudaErrors(cudaSetDevice(dev + dev_start));

    // coeff00 & coeff ==> coeff0 (Adams-Bashforth)
    dim3 dimBlocks(coeff_stride);
    dim3 numBlocks(nparts);
    // as implemented, this actually makes convergence slower
    /*if(dt0 > 0.) {
      predict_coeffs<<<numBlocks, dimBlocks>>>(dt0, dt,
        _pnm_re00[dev], _pnm_im00[dev], _phinm_re00[dev], _phinm_im00[dev],
        _chinm_re00[dev], _chinm_im00[dev],
        _pnm_re0[dev], _pnm_im0[dev], _phinm_re0[dev], _phinm_im0[dev],
        _chinm_re0[dev], _chinm_im0[dev],
        _pnm_re[dev], _pnm_im[dev], _phinm_re[dev], _phinm_im[dev],
        _chinm_re[dev], _chinm_im[dev], coeff_stride);
    }
*/

    checkCudaErrors(cudaMemcpy(_pnm_re00[dev], _pnm_re[dev],
      sizeof(real) * coeff_stride*nparts, cudaMemcpyDeviceToDevice));
    checkCudaErrors(cudaMemcpy(_pnm_im00[dev], _pnm_im[dev],
      sizeof(real) * coeff_stride*nparts, cudaMemcpyDeviceToDevice));
    checkCudaErrors(cudaMemcpy(_phinm_re00[dev], _phinm_re[dev],
      sizeof(real) * coeff_stride*nparts, cudaMemcpyDeviceToDevice));
    checkCudaErrors(cudaMemcpy(_phinm_im00[dev], _phinm_im[dev],
      sizeof(real) * coeff_stride*nparts, cudaMemcpyDeviceToDevice));
    checkCudaErrors(cudaMemcpy(_chinm_re00[dev], _chinm_re[dev],
      sizeof(real) * coeff_stride*nparts, cudaMemcpyDeviceToDevice));
    checkCudaErrors(cudaMemcpy(_chinm_im00[dev], _chinm_im[dev],
      sizeof(real) * coeff_stride*nparts, cudaMemcpyDeviceToDevice));
  }
}
