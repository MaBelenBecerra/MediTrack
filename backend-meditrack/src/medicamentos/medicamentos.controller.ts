import { Controller, Get, Post, Body } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Medicamento } from './medicamento.entity';

@Controller('api/v1/medicamentos')
export class MedicamentosController {
  constructor(
    @InjectRepository(Medicamento)
    private repo: Repository<Medicamento>,
  ) {}

  @Get()
  findAll() {
    return this.repo.find();
  }

  @Post()
  create(@Body() body: Partial<Medicamento>) {
    const med = this.repo.create(body);
    return this.repo.save(med);
  }
}