; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @kernel_jacobi_2d(i64 %0, ptr %1, ptr %2, i64 %3, i64 %4, i64 %5, i64 %6, i64 %7, ptr %8, ptr %9, i64 %10, i64 %11, i64 %12, i64 %13, i64 %14) {
  %16 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %8, 0
  %17 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, ptr %9, 1
  %18 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %17, i64 %10, 2
  %19 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %18, i64 %11, 3, 0
  %20 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %19, i64 %13, 4, 0
  %21 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %20, i64 %12, 3, 1
  %22 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %21, i64 %14, 4, 1
  %23 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %1, 0
  %24 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %23, ptr %2, 1
  %25 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, i64 %3, 2
  %26 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %25, i64 %4, 3, 0
  %27 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %26, i64 %6, 4, 0
  %28 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %27, i64 %5, 3, 1
  %29 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %28, i64 %7, 4, 1
  br label %30

30:                                               ; preds = %427, %15
  %31 = phi i64 [ %428, %427 ], [ 0, %15 ]
  %32 = icmp slt i64 %31, %0
  br i1 %32, label %33, label %429

33:                                               ; preds = %30
  %34 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3
  %35 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %34, ptr %35, align 4
  %36 = getelementptr [2 x i64], ptr %35, i32 0, i64 0
  %37 = load i64, ptr %36, align 4
  %38 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3
  %39 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %38, ptr %39, align 4
  %40 = getelementptr [2 x i64], ptr %39, i32 0, i64 1
  %41 = load i64, ptr %40, align 4
  %42 = icmp sgt i64 %37, 2
  %43 = icmp sgt i64 %41, 2
  %44 = and i1 %42, %43
  br i1 %44, label %45, label %230

45:                                               ; preds = %33
  %46 = sub i64 %37, 2
  %47 = sub i64 %41, 2
  %48 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 0
  %49 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 1
  %50 = insertvalue { ptr, ptr, i64 } poison, ptr %48, 0
  %51 = insertvalue { ptr, ptr, i64 } %50, ptr %49, 1
  %52 = insertvalue { ptr, ptr, i64 } %51, i64 0, 2
  %53 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 2
  %54 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 0
  %55 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 1
  %56 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 0
  %57 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 1
  %58 = add i64 %56, 1
  %59 = extractvalue { ptr, ptr, i64 } %52, 0
  %60 = extractvalue { ptr, ptr, i64 } %52, 1
  %61 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %59, 0
  %62 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %61, ptr %60, 1
  %63 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %62, i64 %58, 2
  %64 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %63, i64 %46, 3, 0
  %65 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %64, i64 %56, 4, 0
  %66 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %65, i64 %47, 3, 1
  %67 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %66, i64 1, 4, 1
  %68 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 0
  %69 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 1
  %70 = insertvalue { ptr, ptr, i64 } poison, ptr %68, 0
  %71 = insertvalue { ptr, ptr, i64 } %70, ptr %69, 1
  %72 = insertvalue { ptr, ptr, i64 } %71, i64 0, 2
  %73 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 2
  %74 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 0
  %75 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 1
  %76 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 0
  %77 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 1
  %78 = extractvalue { ptr, ptr, i64 } %72, 0
  %79 = extractvalue { ptr, ptr, i64 } %72, 1
  %80 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %78, 0
  %81 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %80, ptr %79, 1
  %82 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %81, i64 %76, 2
  %83 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %82, i64 %46, 3, 0
  %84 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %83, i64 %76, 4, 0
  %85 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %84, i64 %47, 3, 1
  %86 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %85, i64 1, 4, 1
  %87 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 0
  %88 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 1
  %89 = insertvalue { ptr, ptr, i64 } poison, ptr %87, 0
  %90 = insertvalue { ptr, ptr, i64 } %89, ptr %88, 1
  %91 = insertvalue { ptr, ptr, i64 } %90, i64 0, 2
  %92 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 2
  %93 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 0
  %94 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 1
  %95 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 0
  %96 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 1
  %97 = add i64 %95, 2
  %98 = extractvalue { ptr, ptr, i64 } %91, 0
  %99 = extractvalue { ptr, ptr, i64 } %91, 1
  %100 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %98, 0
  %101 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %100, ptr %99, 1
  %102 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %101, i64 %97, 2
  %103 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %102, i64 %46, 3, 0
  %104 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %103, i64 %95, 4, 0
  %105 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %104, i64 %47, 3, 1
  %106 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %105, i64 1, 4, 1
  %107 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 0
  %108 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 1
  %109 = insertvalue { ptr, ptr, i64 } poison, ptr %107, 0
  %110 = insertvalue { ptr, ptr, i64 } %109, ptr %108, 1
  %111 = insertvalue { ptr, ptr, i64 } %110, i64 0, 2
  %112 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 2
  %113 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 0
  %114 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 1
  %115 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 0
  %116 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 1
  %117 = mul nsw i64 %115, 2
  %118 = add i64 %117, 1
  %119 = extractvalue { ptr, ptr, i64 } %111, 0
  %120 = extractvalue { ptr, ptr, i64 } %111, 1
  %121 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %119, 0
  %122 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %121, ptr %120, 1
  %123 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %122, i64 %118, 2
  %124 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %123, i64 %46, 3, 0
  %125 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %124, i64 %115, 4, 0
  %126 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %125, i64 %47, 3, 1
  %127 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %126, i64 1, 4, 1
  %128 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 0
  %129 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 1
  %130 = insertvalue { ptr, ptr, i64 } poison, ptr %128, 0
  %131 = insertvalue { ptr, ptr, i64 } %130, ptr %129, 1
  %132 = insertvalue { ptr, ptr, i64 } %131, i64 0, 2
  %133 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 2
  %134 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 0
  %135 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 1
  %136 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 0
  %137 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 1
  %138 = extractvalue { ptr, ptr, i64 } %132, 0
  %139 = extractvalue { ptr, ptr, i64 } %132, 1
  %140 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %138, 0
  %141 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %140, ptr %139, 1
  %142 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %141, i64 1, 2
  %143 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %142, i64 %46, 3, 0
  %144 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %143, i64 %136, 4, 0
  %145 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %144, i64 %47, 3, 1
  %146 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %145, i64 1, 4, 1
  %147 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 0
  %148 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 1
  %149 = insertvalue { ptr, ptr, i64 } poison, ptr %147, 0
  %150 = insertvalue { ptr, ptr, i64 } %149, ptr %148, 1
  %151 = insertvalue { ptr, ptr, i64 } %150, i64 0, 2
  %152 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 2
  %153 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 0
  %154 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 1
  %155 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 0
  %156 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 1
  %157 = add i64 %155, 1
  %158 = extractvalue { ptr, ptr, i64 } %151, 0
  %159 = extractvalue { ptr, ptr, i64 } %151, 1
  %160 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %158, 0
  %161 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %160, ptr %159, 1
  %162 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %161, i64 %157, 2
  %163 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %162, i64 %46, 3, 0
  %164 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %163, i64 %155, 4, 0
  %165 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %164, i64 %47, 3, 1
  %166 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %165, i64 1, 4, 1
  br label %167

167:                                              ; preds = %227, %45
  %168 = phi i64 [ %228, %227 ], [ 0, %45 ]
  %169 = icmp slt i64 %168, %46
  br i1 %169, label %170, label %229

170:                                              ; preds = %167
  br label %171

171:                                              ; preds = %174, %170
  %172 = phi i64 [ %226, %174 ], [ 0, %170 ]
  %173 = icmp slt i64 %172, %47
  br i1 %173, label %174, label %227

174:                                              ; preds = %171
  %175 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %67, 1
  %176 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %67, 2
  %177 = getelementptr double, ptr %175, i64 %176
  %178 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %67, 4, 0
  %179 = mul nsw i64 %168, %178
  %180 = add nsw i64 %179, %172
  %181 = getelementptr inbounds double, ptr %177, i64 %180
  %182 = load double, ptr %181, align 8
  %183 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %86, 1
  %184 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %86, 2
  %185 = getelementptr double, ptr %183, i64 %184
  %186 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %86, 4, 0
  %187 = mul nsw i64 %168, %186
  %188 = add nsw i64 %187, %172
  %189 = getelementptr inbounds double, ptr %185, i64 %188
  %190 = load double, ptr %189, align 8
  %191 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %106, 1
  %192 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %106, 2
  %193 = getelementptr double, ptr %191, i64 %192
  %194 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %106, 4, 0
  %195 = mul nsw i64 %168, %194
  %196 = add nsw i64 %195, %172
  %197 = getelementptr inbounds double, ptr %193, i64 %196
  %198 = load double, ptr %197, align 8
  %199 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %127, 1
  %200 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %127, 2
  %201 = getelementptr double, ptr %199, i64 %200
  %202 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %127, 4, 0
  %203 = mul nsw i64 %168, %202
  %204 = add nsw i64 %203, %172
  %205 = getelementptr inbounds double, ptr %201, i64 %204
  %206 = load double, ptr %205, align 8
  %207 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %146, 1
  %208 = getelementptr double, ptr %207, i64 1
  %209 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %146, 4, 0
  %210 = mul nsw i64 %168, %209
  %211 = add nsw i64 %210, %172
  %212 = getelementptr inbounds double, ptr %208, i64 %211
  %213 = load double, ptr %212, align 8
  %214 = fadd double %182, %190
  %215 = fadd double %214, %198
  %216 = fadd double %215, %206
  %217 = fadd double %216, %213
  %218 = fmul double %217, 2.000000e-01
  %219 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %166, 1
  %220 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %166, 2
  %221 = getelementptr double, ptr %219, i64 %220
  %222 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %166, 4, 0
  %223 = mul nsw i64 %168, %222
  %224 = add nsw i64 %223, %172
  %225 = getelementptr inbounds double, ptr %221, i64 %224
  store double %218, ptr %225, align 8
  %226 = add i64 %172, 1
  br label %171

227:                                              ; preds = %171
  %228 = add i64 %168, 1
  br label %167

229:                                              ; preds = %167
  br label %230

230:                                              ; preds = %229, %33
  %231 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3
  %232 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %231, ptr %232, align 4
  %233 = getelementptr [2 x i64], ptr %232, i32 0, i64 0
  %234 = load i64, ptr %233, align 4
  %235 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3
  %236 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %235, ptr %236, align 4
  %237 = getelementptr [2 x i64], ptr %236, i32 0, i64 1
  %238 = load i64, ptr %237, align 4
  %239 = icmp sgt i64 %234, 2
  %240 = icmp sgt i64 %238, 2
  %241 = and i1 %239, %240
  br i1 %241, label %242, label %427

242:                                              ; preds = %230
  %243 = sub i64 %234, 2
  %244 = sub i64 %238, 2
  %245 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 0
  %246 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 1
  %247 = insertvalue { ptr, ptr, i64 } poison, ptr %245, 0
  %248 = insertvalue { ptr, ptr, i64 } %247, ptr %246, 1
  %249 = insertvalue { ptr, ptr, i64 } %248, i64 0, 2
  %250 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 2
  %251 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 0
  %252 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 1
  %253 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 0
  %254 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 1
  %255 = add i64 %253, 1
  %256 = extractvalue { ptr, ptr, i64 } %249, 0
  %257 = extractvalue { ptr, ptr, i64 } %249, 1
  %258 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %256, 0
  %259 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %258, ptr %257, 1
  %260 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %259, i64 %255, 2
  %261 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %260, i64 %243, 3, 0
  %262 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %261, i64 %253, 4, 0
  %263 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %262, i64 %244, 3, 1
  %264 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %263, i64 1, 4, 1
  %265 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 0
  %266 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 1
  %267 = insertvalue { ptr, ptr, i64 } poison, ptr %265, 0
  %268 = insertvalue { ptr, ptr, i64 } %267, ptr %266, 1
  %269 = insertvalue { ptr, ptr, i64 } %268, i64 0, 2
  %270 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 2
  %271 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 0
  %272 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 1
  %273 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 0
  %274 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 1
  %275 = extractvalue { ptr, ptr, i64 } %269, 0
  %276 = extractvalue { ptr, ptr, i64 } %269, 1
  %277 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %275, 0
  %278 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %277, ptr %276, 1
  %279 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %278, i64 %273, 2
  %280 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %279, i64 %243, 3, 0
  %281 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %280, i64 %273, 4, 0
  %282 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %281, i64 %244, 3, 1
  %283 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %282, i64 1, 4, 1
  %284 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 0
  %285 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 1
  %286 = insertvalue { ptr, ptr, i64 } poison, ptr %284, 0
  %287 = insertvalue { ptr, ptr, i64 } %286, ptr %285, 1
  %288 = insertvalue { ptr, ptr, i64 } %287, i64 0, 2
  %289 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 2
  %290 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 0
  %291 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 1
  %292 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 0
  %293 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 1
  %294 = add i64 %292, 2
  %295 = extractvalue { ptr, ptr, i64 } %288, 0
  %296 = extractvalue { ptr, ptr, i64 } %288, 1
  %297 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %295, 0
  %298 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %297, ptr %296, 1
  %299 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %298, i64 %294, 2
  %300 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %299, i64 %243, 3, 0
  %301 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %300, i64 %292, 4, 0
  %302 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %301, i64 %244, 3, 1
  %303 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %302, i64 1, 4, 1
  %304 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 0
  %305 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 1
  %306 = insertvalue { ptr, ptr, i64 } poison, ptr %304, 0
  %307 = insertvalue { ptr, ptr, i64 } %306, ptr %305, 1
  %308 = insertvalue { ptr, ptr, i64 } %307, i64 0, 2
  %309 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 2
  %310 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 0
  %311 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 1
  %312 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 0
  %313 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 1
  %314 = mul nsw i64 %312, 2
  %315 = add i64 %314, 1
  %316 = extractvalue { ptr, ptr, i64 } %308, 0
  %317 = extractvalue { ptr, ptr, i64 } %308, 1
  %318 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %316, 0
  %319 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %318, ptr %317, 1
  %320 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %319, i64 %315, 2
  %321 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %320, i64 %243, 3, 0
  %322 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %321, i64 %312, 4, 0
  %323 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %322, i64 %244, 3, 1
  %324 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %323, i64 1, 4, 1
  %325 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 0
  %326 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 1
  %327 = insertvalue { ptr, ptr, i64 } poison, ptr %325, 0
  %328 = insertvalue { ptr, ptr, i64 } %327, ptr %326, 1
  %329 = insertvalue { ptr, ptr, i64 } %328, i64 0, 2
  %330 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 2
  %331 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 0
  %332 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 1
  %333 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 0
  %334 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 1
  %335 = extractvalue { ptr, ptr, i64 } %329, 0
  %336 = extractvalue { ptr, ptr, i64 } %329, 1
  %337 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %335, 0
  %338 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %337, ptr %336, 1
  %339 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %338, i64 1, 2
  %340 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %339, i64 %243, 3, 0
  %341 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %340, i64 %333, 4, 0
  %342 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %341, i64 %244, 3, 1
  %343 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %342, i64 1, 4, 1
  %344 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 0
  %345 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 1
  %346 = insertvalue { ptr, ptr, i64 } poison, ptr %344, 0
  %347 = insertvalue { ptr, ptr, i64 } %346, ptr %345, 1
  %348 = insertvalue { ptr, ptr, i64 } %347, i64 0, 2
  %349 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 2
  %350 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 0
  %351 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 1
  %352 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 0
  %353 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 1
  %354 = add i64 %352, 1
  %355 = extractvalue { ptr, ptr, i64 } %348, 0
  %356 = extractvalue { ptr, ptr, i64 } %348, 1
  %357 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %355, 0
  %358 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %357, ptr %356, 1
  %359 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %358, i64 %354, 2
  %360 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %359, i64 %243, 3, 0
  %361 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %360, i64 %352, 4, 0
  %362 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %361, i64 %244, 3, 1
  %363 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %362, i64 1, 4, 1
  br label %364

364:                                              ; preds = %424, %242
  %365 = phi i64 [ %425, %424 ], [ 0, %242 ]
  %366 = icmp slt i64 %365, %243
  br i1 %366, label %367, label %426

367:                                              ; preds = %364
  br label %368

368:                                              ; preds = %371, %367
  %369 = phi i64 [ %423, %371 ], [ 0, %367 ]
  %370 = icmp slt i64 %369, %244
  br i1 %370, label %371, label %424

371:                                              ; preds = %368
  %372 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %264, 1
  %373 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %264, 2
  %374 = getelementptr double, ptr %372, i64 %373
  %375 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %264, 4, 0
  %376 = mul nsw i64 %365, %375
  %377 = add nsw i64 %376, %369
  %378 = getelementptr inbounds double, ptr %374, i64 %377
  %379 = load double, ptr %378, align 8
  %380 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %283, 1
  %381 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %283, 2
  %382 = getelementptr double, ptr %380, i64 %381
  %383 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %283, 4, 0
  %384 = mul nsw i64 %365, %383
  %385 = add nsw i64 %384, %369
  %386 = getelementptr inbounds double, ptr %382, i64 %385
  %387 = load double, ptr %386, align 8
  %388 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %303, 1
  %389 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %303, 2
  %390 = getelementptr double, ptr %388, i64 %389
  %391 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %303, 4, 0
  %392 = mul nsw i64 %365, %391
  %393 = add nsw i64 %392, %369
  %394 = getelementptr inbounds double, ptr %390, i64 %393
  %395 = load double, ptr %394, align 8
  %396 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %324, 1
  %397 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %324, 2
  %398 = getelementptr double, ptr %396, i64 %397
  %399 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %324, 4, 0
  %400 = mul nsw i64 %365, %399
  %401 = add nsw i64 %400, %369
  %402 = getelementptr inbounds double, ptr %398, i64 %401
  %403 = load double, ptr %402, align 8
  %404 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %343, 1
  %405 = getelementptr double, ptr %404, i64 1
  %406 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %343, 4, 0
  %407 = mul nsw i64 %365, %406
  %408 = add nsw i64 %407, %369
  %409 = getelementptr inbounds double, ptr %405, i64 %408
  %410 = load double, ptr %409, align 8
  %411 = fadd double %379, %387
  %412 = fadd double %411, %395
  %413 = fadd double %412, %403
  %414 = fadd double %413, %410
  %415 = fmul double %414, 2.000000e-01
  %416 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %363, 1
  %417 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %363, 2
  %418 = getelementptr double, ptr %416, i64 %417
  %419 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %363, 4, 0
  %420 = mul nsw i64 %365, %419
  %421 = add nsw i64 %420, %369
  %422 = getelementptr inbounds double, ptr %418, i64 %421
  store double %415, ptr %422, align 8
  %423 = add i64 %369, 1
  br label %368

424:                                              ; preds = %368
  %425 = add i64 %365, 1
  br label %364

426:                                              ; preds = %364
  br label %427

427:                                              ; preds = %426, %230
  %428 = add i64 %31, 1
  br label %30

429:                                              ; preds = %30
  ret void
}

define void @_mlir_ciface_kernel_jacobi_2d(i64 %0, ptr %1, ptr %2) {
  %4 = load { ptr, ptr, i64, [2 x i64], [2 x i64] }, ptr %1, align 8
  %5 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 0
  %6 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 1
  %7 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 2
  %8 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 3, 0
  %9 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 3, 1
  %10 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 4, 0
  %11 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 4, 1
  %12 = load { ptr, ptr, i64, [2 x i64], [2 x i64] }, ptr %2, align 8
  %13 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 0
  %14 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %15 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 2
  %16 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 3, 0
  %17 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 3, 1
  %18 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 4, 0
  %19 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 4, 1
  call void @kernel_jacobi_2d(i64 %0, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, i64 %10, i64 %11, ptr %13, ptr %14, i64 %15, i64 %16, i64 %17, i64 %18, i64 %19)
  ret void
}

define void @kernel_seidel_2d(i64 %0, ptr %1, ptr %2, i64 %3, i64 %4, i64 %5, i64 %6, i64 %7) {
  %9 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %1, 0
  %10 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %9, ptr %2, 1
  %11 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %10, i64 %3, 2
  %12 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %11, i64 %4, 3, 0
  %13 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, i64 %6, 4, 0
  %14 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %13, i64 %5, 3, 1
  %15 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, i64 %7, 4, 1
  br label %16

16:                                               ; preds = %121, %8
  %17 = phi i64 [ %122, %121 ], [ 0, %8 ]
  %18 = icmp slt i64 %17, %0
  br i1 %18, label %19, label %123

19:                                               ; preds = %16
  %20 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 3
  %21 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %20, ptr %21, align 4
  %22 = getelementptr [2 x i64], ptr %21, i32 0, i64 0
  %23 = load i64, ptr %22, align 4
  %24 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 3
  %25 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %24, ptr %25, align 4
  %26 = getelementptr [2 x i64], ptr %25, i32 0, i64 1
  %27 = load i64, ptr %26, align 4
  %28 = sub i64 %23, 1
  %29 = sub i64 %27, 1
  br label %30

30:                                               ; preds = %119, %19
  %31 = phi i64 [ %120, %119 ], [ 1, %19 ]
  %32 = icmp slt i64 %31, %28
  br i1 %32, label %33, label %121

33:                                               ; preds = %30
  br label %34

34:                                               ; preds = %37, %33
  %35 = phi i64 [ %118, %37 ], [ 1, %33 ]
  %36 = icmp slt i64 %35, %29
  br i1 %36, label %37, label %119

37:                                               ; preds = %34
  %38 = add i64 %31, -1
  %39 = add i64 %35, -1
  %40 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %41 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %42 = mul nsw i64 %38, %41
  %43 = add nsw i64 %42, %39
  %44 = getelementptr inbounds double, ptr %40, i64 %43
  %45 = load double, ptr %44, align 8
  %46 = add i64 %31, -1
  %47 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %48 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %49 = mul nsw i64 %46, %48
  %50 = add nsw i64 %49, %35
  %51 = getelementptr inbounds double, ptr %47, i64 %50
  %52 = load double, ptr %51, align 8
  %53 = fadd double %45, %52
  %54 = add i64 %31, -1
  %55 = add i64 %35, 1
  %56 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %57 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %58 = mul nsw i64 %54, %57
  %59 = add nsw i64 %58, %55
  %60 = getelementptr inbounds double, ptr %56, i64 %59
  %61 = load double, ptr %60, align 8
  %62 = fadd double %53, %61
  %63 = add i64 %35, -1
  %64 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %65 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %66 = mul nsw i64 %31, %65
  %67 = add nsw i64 %66, %63
  %68 = getelementptr inbounds double, ptr %64, i64 %67
  %69 = load double, ptr %68, align 8
  %70 = fadd double %62, %69
  %71 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %72 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %73 = mul nsw i64 %31, %72
  %74 = add nsw i64 %73, %35
  %75 = getelementptr inbounds double, ptr %71, i64 %74
  %76 = load double, ptr %75, align 8
  %77 = fadd double %70, %76
  %78 = add i64 %35, 1
  %79 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %80 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %81 = mul nsw i64 %31, %80
  %82 = add nsw i64 %81, %78
  %83 = getelementptr inbounds double, ptr %79, i64 %82
  %84 = load double, ptr %83, align 8
  %85 = fadd double %77, %84
  %86 = add i64 %31, 1
  %87 = add i64 %35, -1
  %88 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %89 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %90 = mul nsw i64 %86, %89
  %91 = add nsw i64 %90, %87
  %92 = getelementptr inbounds double, ptr %88, i64 %91
  %93 = load double, ptr %92, align 8
  %94 = fadd double %85, %93
  %95 = add i64 %31, 1
  %96 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %97 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %98 = mul nsw i64 %95, %97
  %99 = add nsw i64 %98, %35
  %100 = getelementptr inbounds double, ptr %96, i64 %99
  %101 = load double, ptr %100, align 8
  %102 = fadd double %94, %101
  %103 = add i64 %31, 1
  %104 = add i64 %35, 1
  %105 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %106 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %107 = mul nsw i64 %103, %106
  %108 = add nsw i64 %107, %104
  %109 = getelementptr inbounds double, ptr %105, i64 %108
  %110 = load double, ptr %109, align 8
  %111 = fadd double %102, %110
  %112 = fdiv double %111, 9.000000e+00
  %113 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %114 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %115 = mul nsw i64 %31, %114
  %116 = add nsw i64 %115, %35
  %117 = getelementptr inbounds double, ptr %113, i64 %116
  store double %112, ptr %117, align 8
  %118 = add i64 %35, 1
  br label %34

119:                                              ; preds = %34
  %120 = add i64 %31, 1
  br label %30

121:                                              ; preds = %30
  %122 = add i64 %17, 1
  br label %16

123:                                              ; preds = %16
  ret void
}

define void @_mlir_ciface_kernel_seidel_2d(i64 %0, ptr %1) {
  %3 = load { ptr, ptr, i64, [2 x i64], [2 x i64] }, ptr %1, align 8
  %4 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 0
  %5 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 1
  %6 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 2
  %7 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 3, 0
  %8 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 3, 1
  %9 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 4, 0
  %10 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 4, 1
  call void @kernel_seidel_2d(i64 %0, ptr %4, ptr %5, i64 %6, i64 %7, i64 %8, i64 %9, i64 %10)
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
