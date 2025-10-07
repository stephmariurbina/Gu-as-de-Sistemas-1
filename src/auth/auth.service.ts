import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { LoginDto } from './dto/login.dto';
import { PrismaService } from 'src/prisma/prisma.service';
import * as bcrypt from 'bcryptjs';


@Injectable()
export class AuthService {
    constructor(
        private jwtservice: JwtService,
        private prisma: PrismaService) {}

        async ValidateUser(user: LoginDto){
            const foundUser = await this.prisma.user.findUnique({
                where: {
                    email: user.email
                }
            });
            
            if (!foundUser) return null;

            //const isPasswordvalid =  await bcrypt.compare(user.password, foundUser.password); 
            const isPasswordvalid = user.password == foundUser.password;
            if (isPasswordvalid){
                return this.jwtservice.sign({
                    id: foundUser.id,
                    email: foundUser.email,
                    role: foundUser.role,
                });
            } else {
                throw new  UnauthorizedException('credenciales invalidas');
            }
        }
}
