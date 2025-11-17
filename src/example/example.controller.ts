import { Body, Controller, Get, Post } from '@nestjs/common';
import { CreateExampleDto } from './dto/create-example.dto';

@Controller('examples')
export class ExampleController {
  private examples: CreateExampleDto[] = [];

  @Get()
  list() {
    return this.examples;
  }

  @Post()
  create(@Body() dto: CreateExampleDto) {
    this.examples.push(dto);
    return dto;
  }
}
